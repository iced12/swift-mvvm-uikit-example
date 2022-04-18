//
//  LoaderCell.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import Foundation
import UIKit

final class LoaderCell: UITableViewCell {
    private let cellView: LoaderCellView = LoaderCellView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(#file)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        setupCellView()
    }
    
    override func prepareForReuse() {
        cellView.resume()
    }
}

extension LoaderCell {
}

private extension LoaderCell {
    func setupCellView() {
        contentView.addSubview(cellView)
    }
}

