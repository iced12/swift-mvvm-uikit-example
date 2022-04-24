//
//  GetRealmSyncObjectUseCase.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 24/04/2022.
//

import Foundation
import RealmSwift

protocol GetOfflineSyncObjectUseCase {
    func getSyncObject(
        onSuccess: @escaping (OfflineSyncObject?) -> Void
    )
}

final class GetOfflineSyncObjectUseCaseImpl: GetOfflineSyncObjectUseCase {
    private let repository: OfflineRepository

    init(repository: OfflineRepository) {
        self.repository = repository
    }

    func getSyncObject(
        onSuccess: @escaping (OfflineSyncObject?) -> Void
    ) {
        repository.getSyncObject(onComplete: onSuccess)
    }
}
