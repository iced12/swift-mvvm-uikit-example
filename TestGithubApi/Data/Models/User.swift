//
//  User.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation

struct User: Codable {
    let id: Int
    let login: String
    let node_id: String
    let avatar_url: String
    let gravatar_id: String
    let url: String
    let html_url: String
}
