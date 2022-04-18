//
//  UsersListViewModel.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation

final class UsersListViewModel {
    var userItems: [UserItemCellViewModel] = []
    var totalUserCount: Int = 0
    var isIncompleteList: Bool = false

    private let userListUseCase: FetchUserListUseCase

    init(userListUseCase: FetchUserListUseCase) {
        self.userListUseCase = userListUseCase
    }
}

extension UsersListViewModel {
    func fetchList(
        onSuccess: @escaping () -> Void,
        onError: @escaping (RestClientError?) -> Void
    ) {
        userListUseCase.fetchUsers(
            userName: "lagos",
            at: 1,
            onSuccess: { [weak self] response in
                guard let response = response else {
                    assertionFailure("Fetch Users response body should not be nil")
                    onSuccess()
                    return
                }
                print(#function, response.items.count)
                self?.userItems = response.items
                    .map { UserItemCellViewModel(user: $0) }
                self?.totalUserCount = response.total_count
                self?.isIncompleteList = response.incomplete_results
                onSuccess()
            },
            onError: onError
        )
    }
}

extension User {
    var userCellModel: UserItemCellViewModel {
        UserItemCellViewModel(user: self)
    }
}
