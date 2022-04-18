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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .white
        return tableView
    }()

    func setup() {
        addSubview(tableView)
    }

    func setupView() {
        backgroundColor = .white

        setupTableView()
//        registerTableView()
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

// MARK - Layout

private extension UsersListView {
    func setupTableView() {
        let constraints = [
            tableView.heightAnchor.constraint(equalToConstant: 800),
            tableView.widthAnchor.constraint(equalToConstant: 375),
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.leftAnchor)
//            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
//            tableView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
