//
//  AppCoordinator.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation
import UIKit

final class AppCoordinator {
    private let mainWindow: UIWindow?
    private var mainNavController: UINavigationController?

    init(window: UIWindow?) {
        self.mainWindow = window
        startCoordinator()
    }
}

private extension AppCoordinator {
    func startCoordinator() {
        let initialView = MainContainer.makeUserListView()
        initialView.coordinatorDelegate = self

        mainNavController = UINavigationController(rootViewController: initialView)
        print("..::", #function, initialView.coordinatorDelegate)

        mainWindow?.rootViewController = mainNavController
        mainWindow?.makeKeyAndVisible()

    }

    func navigateToUserDetails(with user: User) {
        let userDetailsView = MainContainer.makeUserDetailsView(with: user)
//        mainNavController?.present(userDetailsView, animated: true)
        mainNavController?.pushViewController(userDetailsView, animated: true)
    }
}

// MARK - Users List View Coordination

extension AppCoordinator: UsersListCoordinatorDelegate {
    func didSelect(user: User) {
        print(self, #function)
        navigateToUserDetails(with: user)
    }
}

// MARK - User Details View Coordination

extension AppCoordinator {
}

