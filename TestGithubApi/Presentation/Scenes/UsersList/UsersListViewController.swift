//
//  UsersListViewController.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation
import UIKit

private extension Selector {
    static let buttonPressed = #selector(UsersListViewController.buttonPressed)
}

final class UsersListViewController: UIViewController {
    private let mainView: UsersListView
    private let viewModel: UsersListViewModel

    init(view: UsersListView, viewModel: UsersListViewModel) {
        self.mainView = view
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        // TODO: move to base VC
        self.view = mainView
        mainView.setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: move to base VC
        setupView()
        bindView()

        fetchList()
    }

    override func viewDidAppear(_ animated: Bool) {
        print(#function, mainView.frame, mainView.tableView.frame)
    }
}

// MARK - Call ViewModel methods

private extension UsersListViewController {
    func fetchList() {
        viewModel.fetchList(
            onSuccess: showUsersList,
            onError: handleError
        )
    }
}

// MARK - Call View methods

private extension UsersListViewController {
    func setupView() {
        mainView.setupView()
        mainView.setup(with: viewModel)
    }

    func bindView() {
//        mainView.button.addTarget(self, action: .buttonPressed, for: .touchUpInside)
    }

    func showUsersList() {
        DispatchQueue.main.async { [unowned self] in
            self.mainView.updateUsersList()
        }
    }

    func showError() {

    }
}

// MARK - Selectors

private extension UsersListViewController {
    @objc func buttonPressed() {
        print(#function)
    }
}

// MARK - Error handling

private extension UsersListViewController {
    func handleError(error: RestClientError?) {
        //
    }
}

