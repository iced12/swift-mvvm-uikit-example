//
//  FetchUserListUseCase.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation

protocol FetchUserListUseCase {
    func fetchUsers(
        userName: String,
        at page: Int,
        onSuccess: @escaping (UserListResponseDto?) -> Void,
        onError: @escaping (RestClientError?) -> Void
    )
}

final class FetchUserListUseCaseImpl: FetchUserListUseCase {
    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func fetchUsers(
        userName: String,
        at page: Int,
        onSuccess: @escaping (UserListResponseDto?) -> Void,
        onError: @escaping (RestClientError?) -> Void
    ) {
        repository.fetchUsers(userName: userName, at: page) { result in
            switch result {
            case let .success(response):
                return onSuccess(response)
            case let .failure(error):
                print(".failure", error.description)
                ///map to something like a DomainError?
                return onError(error)
            }
        }
    }
}
