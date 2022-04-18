//
//  LoaderCellView.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation
import UIKit

final class LoaderCellView: UIView {
    override var translatesAutoresizingMaskIntoConstraints: Bool {
        get { false }
        set {}
    }

    @UsesAutoLayout
    private var activityIndicator = UIActivityIndicatorView()

    override func didMoveToSuperview() {
        guard let superview = superview else { return }
        let constraints = anchorAll(to: superview)
        NSLayoutConstraint.activate(constraints)

        setupView()
    }

    func setupView() {
        addSubview(activityIndicator)

        let constraints = [
            activityIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            activityIndicator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension LoaderCellView {
    func resume() {
        activityIndicator.startAnimating()
    }

    func stop() {
        activityIndicator.stopAnimating()
    }
}
