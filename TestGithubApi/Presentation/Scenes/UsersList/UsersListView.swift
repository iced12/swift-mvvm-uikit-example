//
//  UsersListView.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation
import UIKit

final class UsersListView: UIView {
    private var viewModel: UsersListViewModel?
    override var translatesAutoresizingMaskIntoConstraints: Bool {
        get { false }
        set {}
    }

    @UsesAutoLayout
    var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .red
        return tableView
    }()

    override func didMoveToSuperview() {
        setup()
    }

    func setup() {
        addSubview(tableView)
    }

    func setupView() {
        backgroundColor = .white

        setupTableView()
        registerTableView()
    }

    func setup(with viewModel: UsersListViewModel) {
        self.viewModel = viewModel
        //TODO
    }
}

extension UsersListView {
    func updateUsersList() {
        tableView.reloadData()
    }
}

// MARK - TableView

extension UsersListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Header"
    }
}

extension UsersListView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10//viewModel?.userItems.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModel = viewModel?.userItems[safe: indexPath.row] else {
            return UITableViewCell()
        }

        let cell = tableView.getCell(ofType: UserItemCell.self)
        cell.setup(with: cellViewModel)
        return cell
    }
}

private extension UsersListView {
    func registerTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.registerCell(ofType: UserItemCell.self)
    }
}

// MARK - Layout

private extension UsersListView {
    func setupTableView() {
        let constraints = [
            tableView.heightAnchor.constraint(equalToConstant: 800),
            tableView.widthAnchor.constraint(equalToConstant: 375),
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
