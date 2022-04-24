//
//  RealmRepository.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 24/04/2022.
//

import Foundation
import RealmSwift

protocol OfflineRepository {
    func getSyncObject(onComplete: @escaping (OfflineSyncObject?) -> Void)
    func update(syncObject: OfflineSyncObject, with latestPage: Int)

    func getAllUsers(onComplete: @escaping (Results<User>) -> Void)
    func upsert(users: [UserDto])
}
