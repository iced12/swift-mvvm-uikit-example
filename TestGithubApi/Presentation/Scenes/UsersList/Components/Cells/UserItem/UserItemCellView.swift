//
//  UserItemCellView.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation
import UIKit

final class UserItemCellView: UIView {
    override var translatesAutoresizingMaskIntoConstraints: Bool {
        get { false }
        set {}
    }

    @UsesAutoLayout
    private var imageView: UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFit
        imgv.image = .init(systemName: Constants.iconPlaceHolder)
        return imgv
    }()

    @UsesAutoLayout
    private var titleLabel = UILabel()

    @UsesAutoLayout
    private var favButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: Constants.favButtonIconEmpty), for: .normal)
        return button
    }()

    override func didMoveToSuperview() {
        //TODO move to base View
        guard let superview = superview else { return }
        let constraints = anchorAll(to: superview)
        NSLayoutConstraint.activate(constraints)

        setupView()
    }

    func setupView() {
        addViews()
        setupImageView()
        setupTitleLabel()
        setupFavButton()
    }

    func setup(with viewModel: UserItemCellViewModel) {
        titleLabel.text = viewModel.user.login
        //TODO image
    }
}

// MARK - Layout

private extension UserItemCellView {
    func addViews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(favButton)
    }

    func setupImageView() {
        let constraints = [
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.commonMargin),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.commonMargin),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.commonMargin),
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageViewSize),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageViewSize)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func setupTitleLabel() {
        let constraints = [
            titleLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: Constants.commonMargin),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func setupFavButton() {
        let constraints = [
            favButton.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: Constants.commonMargin),
            favButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.commonMargin),
            favButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            favButton.widthAnchor.constraint(equalToConstant: Constants.imageViewSize),
            favButton.heightAnchor.constraint(equalToConstant: Constants.imageViewSize)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

private enum Constants {
    static let commonMargin: CGFloat = 16
    static let imageViewSize: CGFloat = 40
    static let favButtonIconEmpty: String = "heart"
    static let favButtonIconFill: String = "heart.fill"
    static let iconPlaceHolder: String = "person.crop.circle"
}
