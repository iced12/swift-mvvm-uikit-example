//
//  OrganizeUserItemsUseCase.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation

protocol SortUserItemsUseCase {
    func sortAlphabetically(dictionary: [String: [UserItemCellType]], with items: [User]) -> [String: [UserItemCellType]]
}

final class SortUserItemsUseCaseImpl: SortUserItemsUseCase {
    func sortAlphabetically(dictionary: [String: [UserItemCellType]], with items: [User]) -> [String: [UserItemCellType]] {
        var newDictionary = dictionary

        for letter in Constants.alphabet {
            let filteredItems = items.filter { user in
                user.login.uppercased().hasPrefix(letter)
            }

            if filteredItems.count > 0 {
                let cellTypes = newDictionary[letter] ?? []
                var newItems = cellTypes.compactMap { $0.user }
                newItems.append(contentsOf: filteredItems)
                newDictionary[letter] = newItems
                    .sorted(by: { $0.login < $1.login} )
                    .map { UserItemCellViewModel(user: $0) }
                    .map { UserItemCellType.userCellType($0) }
            }
        }

        return newDictionary
    }
}

private enum Constants {
    static let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map({ String($0) })
}
