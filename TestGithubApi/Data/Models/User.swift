//
//  User.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 24/04/2022.
//

import Foundation
import RealmSwift

class User: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var login: String
    @Persisted var node_id: String
    @Persisted var avatar_url: String
    @Persisted var gravatar_id: String
    @Persisted var url: String
    @Persisted var html_url: String

    @Persisted var isFavorite: Bool = false
    @Persisted var localImageUrl: String?
}
