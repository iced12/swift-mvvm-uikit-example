//
//  UpdateRealmSyncObjectPage.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 24/04/2022.
//

import Foundation
import RealmSwift

protocol UpdateOfflineSyncObjectPageUseCase {
    func update(
        syncObject: OfflineSyncObject,
        with latestPage: Int
    )
}

final class UpdateOfflineSyncObjectPageUseCaseImpl: UpdateOfflineSyncObjectPageUseCase {
    private let repository: OfflineRepository

    init(repository: OfflineRepository) {
        self.repository = repository
    }

    func update(
        syncObject: OfflineSyncObject,
        with latestPage: Int
    ) {
        repository.update(syncObject: syncObject, with: latestPage)
    }
}
