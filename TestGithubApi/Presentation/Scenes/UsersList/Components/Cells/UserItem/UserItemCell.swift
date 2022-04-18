//
//  UserItemCell.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation
import UIKit

final class UserItemCell: UITableViewCell {
    private let cellView: UserItemCellView = UserItemCellView()

    required init?(coder aDecoder: NSCoder) {
        fatalError(#file)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        setupCellView()
    }
}

extension UserItemCell {
    func setup(with viewModel: UserItemCellViewModel) {
        cellView.setup(with: viewModel)
    }
}

private extension UserItemCell {
    func setupCellView() {
        contentView.addSubview(cellView)
    }
}
