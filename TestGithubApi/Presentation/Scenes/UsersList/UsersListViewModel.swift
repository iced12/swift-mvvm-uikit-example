//
//  UsersListViewModel.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation

enum UserItemCellType {
    case userCellType(UserItemCellViewModel)
    case loader
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

final class UsersListViewModel {
    var userItemCells: [UserItemCellType] = []
    var totalUserCount: Int = 0
    var isIncompleteList: Bool = false
    var isFetching: Bool = false
    var currentPageFetched: Int = 1

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
        isFetching = true
        userListUseCase.fetchUsers(
            userName: Constants.githubUserName,
            at: currentPageFetched,
            onSuccess: { [weak self] response in
                self?.isFetching = false
                guard let response = response else {
                    assertionFailure("Fetch Users response body should not be nil")
                    onSuccess()
                    return
                }
                self?.totalUserCount = response.total_count
                self?.isIncompleteList = response.incomplete_results

                self?.appendItemsAlphabetically(response.items)

                if !response.incomplete_results {
                    self?.appendLoaderItem()
                }

                print("..:: fetched:", self?.userItemCells.count, self?.totalUserCount, self?.isIncompleteList)
                onSuccess()
            },
            onError: { [weak self] error in
                self?.isFetching = false
                onError(error)
            }
        )
    }

    func fetchNextPage(
        onSuccess: @escaping () -> Void,
        onError: @escaping (RestClientError?) -> Void
    ) {
        //check if isInCompleteList works
        if !isIncompleteList {
            currentPageFetched += 1
        }
        fetchList(onSuccess: onSuccess, onError: onError)
    }
}

private extension UsersListViewModel {
    func appendItemsAlphabetically(_ items: [User]) {
        //TODO sort
        userItemCells.removeAll { cellType in
            cellType == .loader
        }
        let cells = items
            .map { UserItemCellViewModel(user: $0) }
            .map { UserItemCellType.userCellType($0) }

        userItemCells.append(contentsOf: cells)
    }

    func appendLoaderItem() {
        userItemCells.append(.loader)
    }
}

private enum Constants {
    static let githubUserName: String = "lagos"
}
