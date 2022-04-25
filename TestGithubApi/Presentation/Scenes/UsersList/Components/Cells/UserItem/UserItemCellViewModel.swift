//
//  UserItemCellViewModel.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation
import RealmSwift

protocol UserItemCellViewModelDelegate: AnyObject {
    func userUpdated()
    func imageLoaded()
}

final class UserItemCellViewModel {
    let user: User
    weak var delegate: UserItemCellViewModelDelegate?

    private var userResultsChangeToken: NotificationToken?

    init(user: User) {
        self.user = user

        observeUser()
    }
}

private extension UserItemCellViewModel {
    func observeUser() {
        userResultsChangeToken = user.observe { [weak self] changes in
            switch changes {
            case .change(_, _):
                self?.delegate?.userUpdated()
            case .error(_), .deleted:
                //TODO
                return
            }
        }
    }
}
