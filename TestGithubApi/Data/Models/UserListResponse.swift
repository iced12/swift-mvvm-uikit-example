//
//  UserListResponse.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation

struct UserListResponse: Codable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [User]
}
