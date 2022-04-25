//
//  FavoriteUserUseCase.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 25/04/2022.
//

import Foundation

protocol FavoriteUserUseCase {
    func toggleFavorite(user: User)
}

final class FavoriteUserUseCaseImpl: FavoriteUserUseCase {
    private let repository: OfflineRepository

    init(repository: OfflineRepository) {
        self.repository = repository
    }

    func toggleFavorite(user: User) {
        repository.toggleFavorite(user: user)
    }
}
