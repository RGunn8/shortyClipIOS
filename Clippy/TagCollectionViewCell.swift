//
//  TagCollectionViewCell.swift
//  Clippy
//
//  Created by Ryan Gunn on 6/6/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {


    let titleLabel: UILabel
      override init(frame: CGRect) {
            // 10.
            titleLabel = UILabel()
            titleLabel.textAlignment = .left
            titleLabel.numberOfLines = 1

            titleLabel.backgroundColor = UIColor.green
            super.init(frame: frame)

            contentView.backgroundColor = UIColor.white

            contentView.addSubview(titleLabel)
            configureLabels()
        }

        func configureLabels() {
            // 11.
            titleLabel.translatesAutoresizingMaskIntoConstraints = false

            let top = titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
            top.priority = UILayoutPriority(999)
            let leading = titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
            let trailing = titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
            NSLayoutConstraint.activate([top, leading, trailing])


        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        // 13.
        override func layoutSubviews() {
            super.layoutSubviews()
            titleLabel.preferredMaxLayoutWidth = titleLabel.frame.size.width
            super.layoutSubviews()
        }
    
}
