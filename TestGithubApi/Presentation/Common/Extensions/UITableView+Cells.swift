//
//  UITableView+Cells.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import UIKit

extension UITableView {
    func registerCell<T: UITableViewCell>(ofType: T.Type) {
        self.register(T.self, forCellReuseIdentifier: String(describing: T.self))
    }

    func getCell<T: UITableViewCell>(ofType: T.Type) -> T {
        if let cell = dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T {
            return cell
        } else {
            fatalError("Could not dequeue cell for type " + String(describing: T.self))
        }
    }
}
