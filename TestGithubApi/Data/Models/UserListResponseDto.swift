//
//  UserListResponse.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation

struct UserListResponseDto: Codable {
    let total_count: Int?
    let incomplete_results: Bool?
    var items: [UserDto]
}
