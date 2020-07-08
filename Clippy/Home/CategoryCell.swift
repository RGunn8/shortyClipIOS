//
//  CategoryCell.swift
//  Clippy
//
//  Created by Ryan Gunn on 7/3/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell{

    let categoryBacgroundView = UIView()
    let categoryTitle = UILabel()

       override init(frame: CGRect) {
           super.init(frame: frame)
        categoryBacgroundView.addCodeConstraints(parentView: self, constraints: [
            categoryBacgroundView.topAnchor.constraint(equalTo: safe().topAnchor, constant: 5),
            categoryBacgroundView.bottomAnchor.constraint(equalTo: safe().bottomAnchor, constant: -5),
            categoryBacgroundView.leadingAnchor.constraint(equalTo: safe().leadingAnchor, constant: 5),
            categoryBacgroundView.trailingAnchor.constraint(equalTo: safe().trailingAnchor, constant: -5),
            categoryBacgroundView.heightAnchor.constraint(equalToConstant: 100),
            categoryBacgroundView.widthAnchor.constraint(equalToConstant: 150)
        ])

        categoryBacgroundView.backgroundColor = .green

        categoryBacgroundView.layoutIfNeeded()
        categoryTitle.addCodeConstraints(parentView: categoryBacgroundView, constraints: [
            categoryTitle.leadingAnchor.constraint(equalTo: categoryBacgroundView.leadingAnchor, constant: 4),
            categoryTitle.trailingAnchor.constraint(equalTo: categoryBacgroundView.trailingAnchor, constant: -4),
            categoryTitle.centerYAnchor.constraint(equalTo: categoryBacgroundView.centerYAnchor)
        ])

       }

       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

}
