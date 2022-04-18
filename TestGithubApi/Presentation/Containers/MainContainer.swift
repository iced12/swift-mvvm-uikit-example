//
//  MainContainer.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation

/**
 Usually i would use some kind of DI lib (like Swinject) to instantiate objects and manage the their scopes ,
 but for this project I will just create them here. Or at least use a container / factory methods to create objects
 */
final class MainContainer {
    private static let restClient: RestClient = RestClientImpl()
    private static let userRequestProvider: RequestProvider = RequestProviderImpl()
    private static var userRepository: UserRepository = UserRepositoryImpl(
        restClient: restClient,
        requestProvider: userRequestProvider
    )

    static func makeUserListView() -> UsersListViewController {
        let fetchUserListUseCase = FetchUserListUseCaseImpl(repository: userRepository)
        let sortUserUseCase = SortUserItemsUseCaseImpl()
        return UsersListViewController(
            view: UsersListView(),
            viewModel: UsersListViewModel(
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
