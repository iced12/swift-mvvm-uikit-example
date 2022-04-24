//
//  UserRepositoryImpl.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation

final class UserRepositoryImpl: UserRepository {
    private let restClient: RestClient
    private let requestProvider: RequestProvider

    init(
        restClient: RestClient,
        requestProvider: RequestProvider
    ) {
        self.restClient = restClient
        self.requestProvider = requestProvider
    }

    func fetchUsers(
        userName: String,
        at page: Int,
        onComplete: @escaping (UserListReponseResult) -> Void
    ) {
        guard let request = requestProvider.makeUserListRequest(for: userName, at: page) else { return }

        restClient.execute(request: request, with: UserListResponseDto.self) { result in
            DispatchQueue.main.async {
                onComplete(result)
            }
        }
    }
}
