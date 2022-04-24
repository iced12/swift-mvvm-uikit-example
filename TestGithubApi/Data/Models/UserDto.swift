//
//  User.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation

struct UserDto: Codable {
    let id: Int
    let login: String
    let node_id: String
    let avatar_url: String
    let gravatar_id: String
    let url: String
    let html_url: String
}

extension UserDto {
    var toRealmUser: User {
        let user = User()
        user.id = id
        user.login = login
        user.node_id = node_id
        user.avatar_url = avatar_url
        user.gravatar_id = gravatar_id
        user.url = url
        user.html_url = html_url
        return user
    }
}
