//
//  RealmRepositoryImpl.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 24/04/2022.
//

import Foundation
import RealmSwift

final class RealmRepositoryImpl: OfflineRepository {
    init() {
        guard let _ = try? Realm() else {
            assertionFailure("Realm was not created. Perhaps try to migrate Realm.")
            return
        }
    }
}

// MARK - Sync object

extension RealmRepositoryImpl {
    func getSyncObject(onComplete: @escaping (OfflineSyncObject?) -> Void) {
        /** For the simplicity of this project I will just do everything Realm-related in the main thread */
        DispatchQueue.main.async {
            let realm = try! Realm()
            let results = realm.objects(OfflineSyncObject.self)
            onComplete(results.first)
        }
    }

    func update(syncObject: OfflineSyncObject, with latestPage: Int) {
        DispatchQueue.main.async {
            let realm = try! Realm()

            guard let object = realm.objects(OfflineSyncObject.self).first else {
                try! realm.write {
                    realm.add(syncObject)
                }
                return
            }

            try! realm.write {
                object.latestPageSynced = latestPage
            }
        }
    }
}

// MARK - Users

extension RealmRepositoryImpl {
    func getAllUsers(onComplete: @escaping (Results<User>) -> Void) {
        DispatchQueue.main.async {
            let realm = try! Realm()
            let results = realm.objects(User.self)
            onComplete(results)

        }
    }

    func upsert(users: [UserDto]) {
        DispatchQueue.main.async {
            let Users = users.map { $0.toRealmUser }
            let realm = try! Realm()
            try! realm.write {
                realm.add(Users, update: .modified)
            }

        }
    }
}
