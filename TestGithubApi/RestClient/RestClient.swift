//
//  RestClient.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation

public enum RestClientError: Error {
    case jsonParse(className: String)
    case network(statusCode: Int)
    case unknown(Error?)

    var description: String {
        switch self{
        case let .unknown(error):
            return error?.localizedDescription ?? "Generic error message"
        case let .jsonParse(className):
            return "An Error ocurred while parsing Json for class: \(className)"
        case let .network(statusCode):
            return "Network error with Http status code: \(statusCode)"
        }
    }
}

public protocol RestClient {
    func execute<T: Decodable>(
        request: URLRequest,
        with model: T.Type,
        onComplete: @escaping (Result<T?, RestClientError>) -> Void
    )
}

public class RestClientImpl: RestClient {
    private let decoder: JSONDecoder

    public init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }

    public func execute<T: Decodable>(
        request: URLRequest,
        with model: T.Type,
        onComplete: @escaping (Result<T?, RestClientError>) -> Void
    ){
        let task = URLSession.shared
            .dataTask(with: request) { [unowned self] data, response, error in
                if let error = error {
                    return onComplete(.failure(.unknown(error)))
                }

                guard let httpUrlResponse = response as? HTTPURLResponse else {
                    onComplete(Result.failure(RestClientError.unknown(error)))
                    return
                }

                switch httpUrlResponse.statusCode {
                case 200...299:
                    guard let data = data else {
                        /// in case there's no response body (like http 204) return success without model
                        return onComplete(.success(nil))
                    }
                    let result = decoder.decode(model: T.self, data: data)
                    onComplete(result)

                default:
                    /// for the sake of simplicity in this project, I'm just going to assume all codes between 200 and 299 are success and the rest are some kind of error
                    return onComplete(.failure(
                        .network(statusCode: httpUrlResponse.statusCode))
                    )
                }
            }
        task.resume()
    }
}

private extension JSONDecoder {
    func decode<T: Decodable>(model: T.Type, data: Data) -> Result<T?, RestClientError> {
        do {
            let model = try decode(T.self, from: data)
            return .success(model)
        } catch {
            return .failure(.jsonParse(className: String(describing: T.self)))
        }
    }
}
