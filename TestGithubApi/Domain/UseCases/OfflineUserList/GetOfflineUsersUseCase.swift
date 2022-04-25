//
//  GetOfflineUsersUseCase.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 24/04/2022.
//

import Foundation
import RealmSwift

protocol GetOfflineUsersUseCase {
    func getUsers(
        onSuccess: @escaping (Results<User>) -> Void
    )
}

final class GetOfflineUsersUseCaseImpl: GetOfflineUsersUseCase {
    private let repository: OfflineRepository

    init(repository: OfflineRepository) {
        self.repository = repository
    }

    func getUsers(
        onSuccess: @escaping (Results<User>) -> Void
    ) {
        repository.getAllUsers(onComplete: onSuccess)
    }
}
