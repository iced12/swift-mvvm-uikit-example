//
//  UsersListViewModel.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation

final class UsersListViewModel {
    var userItemCells: [String: [UserItemCellType]] = [:]
    var sortedKeys: [String] = []
    var totalUserCount: Int = 0
    var isIncompleteList: Bool = false
    var isFetching: Bool = false
    var currentPageFetched: Int = 1

    private let userListUseCase: FetchUserListUseCase
    private let sortUserItemsUseCase: SortUserItemsUseCase

    init(
        userListUseCase: FetchUserListUseCase,
        sortUserItemsUseCase: SortUserItemsUseCase
    ) {
        self.userListUseCase = userListUseCase
        self.sortUserItemsUseCase = sortUserItemsUseCase
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

                self?.sort(newItems: response.items)

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
    func sort(newItems: [User]) {
        clearLoaderItem()
        userItemCells = sortUserItemsUseCase
            .sortAlphabetically(dictionary: userItemCells, with: newItems)
        sortedKeys = userItemCells.keys.sorted()
    }

    func appendLoaderItem() {
        var lastSection = userItemCells.lastSectionValues
        lastSection?.append(.loader)
    }

    func clearLoaderItem() {
        var lastSection = userItemCells.lastSectionValues
        lastSection?.removeAll { $0 == .loader }
    }
}

private enum Constants {
    static let githubUserName: String = "lagos"
    static let loaderSectionKey: String = "!LoaderSection"
}
