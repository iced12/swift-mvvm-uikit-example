//
//  UsersListView.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation
import UIKit

final class UsersListView: UIView {
    @UsesAutoLayout
    var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .white
        return tableView
    }()

    func setupView() {
        backgroundColor = .white

        addSubviews()
        setupTableView()
    }

    func addSubviews() {
        addSubview(tableView)
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
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
