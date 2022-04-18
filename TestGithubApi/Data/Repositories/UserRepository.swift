//
//  UserRepository.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation

typealias UserListReponseResult = Result<UserListResponse?, RestClientError>

protocol UserRepository {
    func fetchUsers(
        userName: String,
        at page: Int,
        onComplete: @escaping (UserListReponseResult) -> Void
    )
}
