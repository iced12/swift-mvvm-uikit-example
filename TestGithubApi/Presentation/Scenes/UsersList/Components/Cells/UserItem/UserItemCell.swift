//
//  UserItemCell.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation
import UIKit

protocol UITableViewCellDelegate: AnyObject {
    func favoriteButtonTapped(for user: User)
}

final class UserItemCell: UITableViewCell {
    weak var delegate: UITableViewCellDelegate?

    private var viewModel: UserItemCellViewModel?
    private var buttonImageAsset: String {
        viewModel?.user.isFavorite == true
            ? Constants.favButtonIconFill
            : Constants.favButtonIconEmpty
    }

    @UsesAutoLayout
    private var imgView: UIImageView = {
        let imgv = UIImageView()
        imgv.contentMode = .scaleAspectFit
        imgv.image = .init(systemName: Constants.iconPlaceHolder)
        return imgv
    }()

    @UsesAutoLayout
    private var titleLabel = UILabel()

    @UsesAutoLayout
    private var favButton = UIButton()

    required init?(coder aDecoder: NSCoder) {
        fatalError(#file)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.isUserInteractionEnabled = true

        setupCellView()
    }
}

// MARK - Setup

extension UserItemCell {
    func setup(with viewModel: UserItemCellViewModel) {
        self.viewModel = viewModel
        titleLabel.text = viewModel.user.login
        updateFavButton()

        viewModel.delegate = self
    }
}

private extension UserItemCell {
    func setupCellView() {
        addViews()
        setupImageView()
        setupTitleLabel()
        setupFavButton()

        favButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
}

// MARK - Actions

private extension UserItemCell {
    @objc func favoriteButtonTapped() {
        guard let user = viewModel?.user else { return }
        delegate?.favoriteButtonTapped(for: user)
        updateFavButton()
    }

    func updateFavButton() {
        favButton.setImage(.init(systemName: buttonImageAsset), for: .normal)
    }
}

extension UserItemCell: UserItemCellViewModelDelegate {
    func userUpdated() {
        updateFavButton()
    }

    func imageLoaded() {
        //TODO
    }
}

// MARK - Layout

private extension UserItemCell {
    func addViews() {
        contentView.addSubview(imgView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(favButton)
    }

    func setupImageView() {
        let heightAnchor = imgView.heightAnchor.constraint(equalToConstant: Constants.imageViewSize)
        let constraints = [
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.commonMargin),
            imgView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constants.commonMargin),
            imgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.commonMargin),
            imgView.widthAnchor.constraint(equalToConstant: Constants.imageViewSize),
            heightAnchor
        ]
        heightAnchor.priority = .defaultHigh
        NSLayoutConstraint.activate(constraints)
    }

    func setupTitleLabel() {
        let constraints = [
            titleLabel.leftAnchor.constraint(equalTo: imgView.rightAnchor, constant: Constants.commonMargin),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func setupFavButton() {
        let constraints = [
            favButton.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: Constants.commonMargin),
            favButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constants.commonMargin),
            favButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
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
