//
//  UserDetailsViewController.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 18/04/2022.
//

import Foundation
import UIKit

final class UserDetailsViewController: UIViewController {
    private let mainView: UserDetailsView
    private let viewModel: UserDetailsViewModel

    init(view: UserDetailsView, viewModel: UserDetailsViewModel) {
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

        title = viewModel.user.login
    }
}

// MARK - View methods

private extension UserDetailsViewController {
    func setupView() {
        mainView.setupView()
        mainView.setup(with: viewModel)
    }
}
