//
//  AppCoordinator.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation
import UIKit

final class AppCoordinator {
    private var mainWindow: UIWindow?
    private let mainScene: UIWindowScene
    private var mainNavController: UINavigationController?

    init(mainScene: UIWindowScene) {
        self.mainScene = mainScene
        startCoordinator()
    }
}

private extension AppCoordinator {
    func startCoordinator() {
        let initialView = MainContainer.makeUserListView()
        mainNavController = UINavigationController(rootViewController: initialView)

        mainWindow = UIWindow(windowScene: mainScene)
        mainWindow?.rootViewController = mainNavController
        mainWindow?.makeKeyAndVisible()
    }
}
