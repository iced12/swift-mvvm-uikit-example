//
//  RealmSyncObject.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 24/04/2022.
//

import Foundation
import RealmSwift

class OfflineSyncObject: Object {
    @Persisted var latestPageSynced: Int
}
