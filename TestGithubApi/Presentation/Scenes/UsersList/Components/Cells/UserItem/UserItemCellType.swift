//
//  UserItemCellType.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation

enum UserItemCellType {
    case userCellType(UserItemCellViewModel)
    case loader
}

extension UserItemCellType {
    var user: User? {
        if case let .userCellType(model) = self {
            return model.user
        }
        return nil
    }
}

extension UserItemCellType: Equatable {
    static func == (lhs: UserItemCellType, rhs: UserItemCellType) -> Bool {
        switch (lhs, rhs) {
        case (.loader, .loader): return true
        case (.userCellType(_), .userCellType(_)): return true
        default: return false
        }
    }
}
