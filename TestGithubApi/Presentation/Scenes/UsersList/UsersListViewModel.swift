//
//  UsersListViewModel.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation
import RealmSwift

/**
Caching strategy is a complex topic and takes some time to analyze and implement.
In case of this project, since it's "Offline first" I will go with the approach to always check the offline data first,
and only when the user scrolls down to the last available item offline, then the app will fetch next items.
This approach is obviously not the best for a real world application :)
*/


final class UsersListViewModel {
    var userItemCells: [String: [UserItemCellType]] = [:]
    var sortedKeys: [String] = []
    private var totalUserCount: Int = 0
    private var isIncompleteList: Bool = false

    private var currentPageFetched: Int = 1

    /**
    Properly there should be somekind of manager to manage the state of synchronization between local DB and remote
    Either to use to Sync feature of MongoDB or else at least to have a property of last sync / last changed
    */
    private var syncObject: OfflineSyncObject?

    private let userListUseCase: FetchUserListUseCase
    private let sortUserItemsUseCase: SortUserItemsUseCase
    private let getSyncObjectUseCase: GetOfflineSyncObjectUseCase
    private let updateSyncObjectPageUseCase: UpdateOfflineSyncObjectPageUseCase
    private let getOfflineUsersUseCase: GetOfflineUsersUseCase
    private let upsertOfflineUsersUseCase: UpsertOfflineUsersUseCase
    private let favoriteUserUseCase: FavoriteUserUseCase

    init(
        getSyncObjectUseCase: GetOfflineSyncObjectUseCase,
        updateSyncObjectPageUseCase: UpdateOfflineSyncObjectPageUseCase,
        getOfflineUsersUseCase: GetOfflineUsersUseCase,
        upsertOfflineUsersUseCase: UpsertOfflineUsersUseCase,
        userListUseCase: FetchUserListUseCase,
        sortUserItemsUseCase: SortUserItemsUseCase,
        favoriteUserUseCase: FavoriteUserUseCase
    ) {
        self.getSyncObjectUseCase = getSyncObjectUseCase
        self.updateSyncObjectPageUseCase = updateSyncObjectPageUseCase
        self.getOfflineUsersUseCase = getOfflineUsersUseCase
        self.upsertOfflineUsersUseCase = upsertOfflineUsersUseCase

        self.userListUseCase = userListUseCase
        self.sortUserItemsUseCase = sortUserItemsUseCase
        self.favoriteUserUseCase = favoriteUserUseCase
    }
}

extension UsersListViewModel {
    func getSyncObject() {
        getSyncObjectUseCase.getSyncObject { [weak self] syncObject in
            self?.syncObject = syncObject
            self?.currentPageFetched = syncObject?.latestPageSynced ?? 1
        }
    }

    func getInitialUsers (
        onSuccess: @escaping () -> Void,
        onError: @escaping (RestClientError?) -> Void
    ) {
        getOfflineUsersUseCase.getUsers { [weak self] results in
            let users: [User] = results.map { $0 }

            if users.count > 0 {
                self?.append(newUsers: users)
                onSuccess()
            } else {
                self?.fetchList(
                    onSuccess: onSuccess,
                    onError: onError
                )
            }
        }
    }

    func fetchNextPage(
        onSuccess: @escaping () -> Void,
        onError: @escaping (RestClientError?) -> Void
    ) {
        // TODO: check if isInCompleteList means there's more to load
        if !isIncompleteList {
            currentPageFetched += 1
        }
        fetchList(onSuccess: onSuccess, onError: onError)
    }

    func toggleFavorite(user: User) {
        favoriteUserUseCase.toggleFavorite(user: user)
    }
}

private extension UsersListViewModel {
    func fetchList(
        onSuccess: @escaping () -> Void,
        onError: @escaping (RestClientError?) -> Void
    ) {
        userListUseCase.fetchUsers(
            userName: Constants.githubUserName,
            at: currentPageFetched,
            onSuccess: { [weak self] response in
                guard let response = response else {
                    assertionFailure("Fetch Users response body should not be nil in this case")
                    return
                }

                self?.totalUserCount = response.total_count ?? 0
                self?.isIncompleteList = response.incomplete_results ?? false

                if response.incomplete_results == true {
                    self?.appendLoaderItem()
                }

                self?.updateSyncObject()
                self?.upsertOfflineUsersUseCase.upsertUsers(response.items) { [weak self] users in
                    self?.append(newUsers: users)
                    onSuccess()
                }
            },
            onError: onError
        )
    }

    func updateSyncObject() {
        updateSyncObjectPageUseCase.update(
            syncObject: syncObject ?? OfflineSyncObject(),
            with: currentPageFetched
        )
    }
}

private extension UsersListViewModel {
    func append(newUsers: [User]) {
        clearLoaderItem()
        userItemCells = sortUserItemsUseCase
            .sortAlphabetically(dictionary: userItemCells, with: newUsers)
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
