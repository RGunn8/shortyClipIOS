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
            titleLabel = UILabel()
            titleLabel.textAlignment = .left
            titleLabel.numberOfLines = 1
            super.init(frame: frame)
            contentView.backgroundColor = UIColor.clear
            contentView.addSubview(titleLabel)
            configureLabels()
        }

        func configureLabels() {
            titleLabel.addCodeConstraints(parentView: self, constraints: [
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
                titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            ])

            


        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    
        override func layoutSubviews() {
            super.layoutSubviews()
            titleLabel.preferredMaxLayoutWidth = titleLabel.frame.size.width
            super.layoutSubviews()
        }
    
}
