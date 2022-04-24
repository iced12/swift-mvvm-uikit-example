//
//  UpsertUsersUseCase.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 24/04/2022.
//

import Foundation
import RealmSwift

protocol UpsertOfflineUsersUseCase {
    func upsertUsers(
        _ users: [UserDto]
    )
}

final class UpsertOfflineUsersUseCaseImpl: UpsertOfflineUsersUseCase {
    private let repository: OfflineRepository

    init(repository: OfflineRepository) {
        self.repository = repository
    }

    func upsertUsers(
        _ users: [UserDto]
    ) {
        repository.upsert(users: users)
    }
}
