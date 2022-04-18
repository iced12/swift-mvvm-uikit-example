//
//  UsersListViewController.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation
import UIKit

private extension Selector {
}

protocol UsersListCoordinatorDelegate: AnyObject {
    func didSelect(user: User)
}

final class UsersListViewController: UIViewController {
    private let mainView: UsersListView
    private let viewModel: UsersListViewModel

    var coordinatorDelegate: UsersListCoordinatorDelegate?

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

        title = "Users"

        fetchList()
    }

    override func viewDidAppear(_ animated: Bool) {
        mainView.setNeedsLayout()
        mainView.layoutSubviews()
        print(#function, mainView.frame, mainView.tableView.frame)
    }
}

// MARK - ViewModel methods

private extension UsersListViewController {
    func fetchList() {
        viewModel.fetchList(
            onSuccess: updateUsersList,
            onError: handleError
        )
    }
}

// MARK - View methods

private extension UsersListViewController {
    func setupView() {
        mainView.setupView()
        mainView.setup(with: viewModel)
        registerTableView()
    }

    func bindView() {
        //        mainView.button.addTarget(self, action: .buttonPressed, for: .touchUpInside)
    }

    func updateUsersList() {
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

// MARK - TableView
private extension UsersListViewController {
    func registerTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self

        mainView.tableView.registerCell(ofType: UserItemCell.self)
        mainView.tableView.registerCell(ofType: LoaderCell.self)
    }
}

extension UsersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellType = viewModel.userItemCells[safe: indexPath.row] else { return }
        if case let .userCellType(cellViewModel) = cellType {
            didSelect(user: cellViewModel.user)
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Header"
    }
}

extension UsersListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userItemCells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = viewModel.userItemCells[safe: indexPath.row] else {
            return UITableViewCell()
        }
        switch cellType {
        case let .userCellType(cellViewModel):
            let cell = tableView.getCell(ofType: UserItemCell.self)
            cell.setup(with: cellViewModel)
            return cell
        case .loader:
            return tableView.getCell(ofType: LoaderCell.self)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //TODO also check sections after sorting alphabetically
        let totalItems = viewModel.userItemCells.count - 1

        let isLast = indexPath.row == totalItems

        if isLast {
            viewModel.fetchNextPage(
                onSuccess: updateUsersList,
                onError: handleError
            )
        }
    }
}

// MARK - Navigation

private extension UsersListViewController {
    func didSelect(user: User) {
        coordinatorDelegate?.didSelect(user: user)
    }
}
