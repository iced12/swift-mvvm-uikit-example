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
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: move to base VC
        setupView()

        title = "Users"

        setupViewModel()
    }
}

// MARK - ViewModel methods

private extension UsersListViewController {
    func setupViewModel() {
        viewModel.getSyncObject()

        viewModel.getInitialUsers(
            onSuccess: updateUsersList,
            onError: handleError
        )
    }
}

// MARK - View methods

private extension UsersListViewController {
    func setupView() {
        mainView.setupView()
        //        mainView.setup(with: viewModel)
        registerTableView()
    }

    func updateUsersList() {
        DispatchQueue.main.async { [unowned self] in
            self.mainView.updateUsersList()
        }
    }
}


// MARK - Error handling

private extension UsersListViewController {
    func handleError(error: RestClientError?) {
        //TODO handle errors and show in mainView
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
        guard
            let key = viewModel.sortedKeys[safe: indexPath.section],
            let values = viewModel.userItemCells[key],
            let cellType = values[safe: indexPath.row]
        else { return }
        
        if case let .userCellType(cellViewModel) = cellType {
            didSelect(user: cellViewModel.user)
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.sortedKeys[safe: section]
    }
}

extension UsersListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.userItemCells.keys.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard
            let key = viewModel.sortedKeys[safe: section],
            let values = viewModel.userItemCells[key]
        else { return 0 }

        return values.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let key = viewModel.sortedKeys[safe: indexPath.section],
            let values = viewModel.userItemCells[key],
            let cellType = values[safe: indexPath.row]
        else {
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
        let lastKeyPosition = viewModel.sortedKeys.count - 1

        guard let lastSectionValues = viewModel.userItemCells.lastSectionValues else { return }

        let isLastSection = indexPath.section == lastKeyPosition
        let isLastRow = indexPath.row == lastSectionValues.count - 1

        if isLastSection && isLastRow {
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


extension Dictionary where Key == String, Value == [UserItemCellType] {
    func key(at position: Int) -> String {
        keys[index(startIndex, offsetBy: position)]
    }

    func values(at position: Int) -> Value? {
        self[key(at: position)]
    }

    func value(at index: IndexPath) -> UserItemCellType? {
        let values = self[key(at: index.section)]
        return values?[safe: index.row]
    }

    var lastSectionValues: [UserItemCellType]? {
        guard let lastKey = keys.sorted().reversed().first else { return nil }
        return self[lastKey]
    }

    var sortedAlphabetically: [String: [UserItemCellType]] {
        let sortedKeys = keys.sorted()
        var newDictionary: [String: [UserItemCellType]] = [:]

        for key in sortedKeys {
            if let values = self[key] {
                newDictionary[key] = values
            }
        }

        return newDictionary
    }
}
