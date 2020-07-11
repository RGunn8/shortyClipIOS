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
    let categoryIcon = UIImageView()
       override init(frame: CGRect) {
           super.init(frame: frame)
        self.backgroundColor = .clear
        categoryBacgroundView.addCodeConstraints(parentView: self, constraints: [
            categoryBacgroundView.topAnchor.constraint(equalTo: safe().topAnchor, constant: 5),
            categoryBacgroundView.bottomAnchor.constraint(equalTo: safe().bottomAnchor, constant: -5),
            categoryBacgroundView.leadingAnchor.constraint(equalTo: safe().leadingAnchor, constant: 5),
            categoryBacgroundView.trailingAnchor.constraint(equalTo: safe().trailingAnchor, constant: -5),
            //categoryBacgroundView.heightAnchor.constraint(equalToConstant: 100),
            //categoryBacgroundView.widthAnchor.constraint(equalToConstant: 150)
        ])

        categoryBacgroundView.backgroundColor = .oxfordBlue

        categoryBacgroundView.layoutIfNeeded()


        categoryIcon.addCodeConstraints(parentView: categoryBacgroundView, constraints: [
                   categoryIcon.leadingAnchor.constraint(equalTo: categoryBacgroundView.leadingAnchor, constant: 30),
                   categoryIcon.trailingAnchor.constraint(equalTo: categoryBacgroundView.trailingAnchor, constant: -30),
                   categoryIcon.centerYAnchor.constraint(equalTo: categoryBacgroundView.centerYAnchor),
            categoryIcon.heightAnchor.constraint(equalToConstant: 70)
               ])

        categoryIcon.image = UIImage(named: "joystick")?.withTintColor(.white).withRenderingMode(.alwaysTemplate)
       // categoryIcon.tintColor = .white

        categoryTitle.addCodeConstraints(parentView: categoryBacgroundView, constraints: [
                  categoryTitle.leadingAnchor.constraint(equalTo: categoryBacgroundView.leadingAnchor, constant: 4),
                  categoryTitle.trailingAnchor.constraint(equalTo: categoryBacgroundView.trailingAnchor, constant: -4),
                  categoryTitle.topAnchor.constraint(equalTo: categoryIcon.bottomAnchor, constant: 10),
                  categoryTitle.centerXAnchor.constraint(equalTo: categoryIcon.centerXAnchor)
              ])

              categoryTitle.textAlignment = .center
        categoryTitle.textColor = .white


       }

       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

}
