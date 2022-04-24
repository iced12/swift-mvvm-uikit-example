//
//  MainContainer.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation

/**
 Usually i would use some kind of DI lib (like Swinject) to instantiate objects and manage their scopes ,
 But to keep this project simple and also to not use too many external libs I will use containers to manage the scopes of objects
 */
final class MainContainer {
    /**
    some classes like restClient, repositories should be created once per container (module) and shared among objects of the same container,
    or in case of this project as a singleton for the whole project
    some classes like UseCases should be created everytime it is needed
    */
    private static let restClient: RestClient = RestClientImpl()
    private static let userRequestProvider: RequestProvider = RequestProviderImpl()
    private static var userRepository: UserRepository = UserRepositoryImpl(
        restClient: restClient,
        requestProvider: userRequestProvider
    )
    private static let offlineRepository: OfflineRepository = RealmRepositoryImpl()

    static func makeUserListView() -> UsersListViewController {
        let getSyncObjectUseCase = GetOfflineSyncObjectUseCaseImpl(repository: offlineRepository)
        let updateSyncObjectPageUseCase = UpdateOfflineSyncObjectPageUseCaseImpl(repository: offlineRepository)
        let getOfflineUsersUseCase = GetOfflineUsersUseCaseImpl(repository: offlineRepository)
        let upsertOfflineUsersUseCase = UpsertOfflineUsersUseCaseImpl(repository: offlineRepository)

        let fetchUserListUseCase = FetchUserListUseCaseImpl(repository: userRepository)
        let sortUserUseCase = SortUserItemsUseCaseImpl()

        return UsersListViewController(
            view: UsersListView(),
            viewModel: UsersListViewModel(
                getSyncObjectUseCase: getSyncObjectUseCase,
                updateSyncObjectPageUseCase: updateSyncObjectPageUseCase,
                getOfflineUsersUseCase: getOfflineUsersUseCase,
                upsertOfflineUsersUseCase: upsertOfflineUsersUseCase,
                userListUseCase: fetchUserListUseCase,
                sortUserItemsUseCase: sortUserUseCase
            )
        )
    }

    static func makeUserDetailsView(with user: User) -> UserDetailsViewController {
        return UserDetailsViewController(
            view: UserDetailsView(),
            viewModel: UserDetailsViewModel(user: user)
        )
    }
}
