//
//  RequestProvider.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation

enum HttpMethod: String {
    case post, get, delete, put
}

protocol RequestProvider {
    func makeUserListRequest(for user: String, at page: Int ) -> URLRequest?
}

final class RequestProviderImpl: RequestProvider {
    func makeUserListRequest(for user: String, at page: Int ) -> URLRequest? {
        let endpoint = "/search/users"
        let userQuery = URLQueryItem(name: "q", value: "\(user)")
        let pageQuery = URLQueryItem(name: "page", value: "\(page)")
        let queries = [userQuery, pageQuery]

        return createRequest(
            with: endpoint,
            method: .get,
            queries: queries
        )
    }
}

private extension RequestProviderImpl {
    func createRequest(
        with endpoint: String,
        method: HttpMethod,
        queries: [URLQueryItem]? = nil,
        body: Data? = nil
    ) -> URLRequest? {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.host
        components.path = endpoint
        components.queryItems = queries

        guard let url = components.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body

        return request
    }
}

private enum Constants {
    static let scheme = "https"
    static let host = "api.github.com" //TODO: move to config or plist
}
