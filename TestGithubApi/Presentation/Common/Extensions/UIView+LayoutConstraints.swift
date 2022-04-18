//
//  UIView+LayoutConstraints.swift
//  TestGithubApi
//
//  Created by Minh Le Ngoc on 17/04/2022.
//

import UIKit

extension UIView {
    func anchorAll(to safeArea: UILayoutGuide) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: safeArea.topAnchor),
            leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            rightAnchor.constraint(equalTo: safeArea.rightAnchor)
        ]
    }

    func anchorAll(to superview: UIView) -> [NSLayoutConstraint] {
        return [
            topAnchor.constraint(equalTo: superview.topAnchor),
            leftAnchor.constraint(equalTo: superview.leftAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            rightAnchor.constraint(equalTo: superview.rightAnchor)
        ]
    }
}
