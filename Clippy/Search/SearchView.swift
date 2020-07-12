//
//  SearchView.swift
//  Clippy
//
//  Created by Ryan Gunn on 7/11/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import UIKit

class SearchView: UIView {
    let searchTableView = UITableView()
    let spinner = UIActivityIndicatorView(style: .large)
    let popularsSearchLabel = UILabel()
    let popularSearchStackView = UIStackView()

    override init(frame: CGRect) {
          super.init(frame: frame)
          self.backgroundColor = UIColor.white
          setUpSearchView()
        }

      override func prepareForInterfaceBuilder() {
         setUpSearchView()

      }

    required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
        }

    func setUpSearchView(){
        setUpSearchTableView()
        setUpSpinner()
        setUpPopularLabel()
        setUpPopularStackView()
    }

    func setUpSearchTableView(){
        searchTableView.addCodeConstraints(parentView: self, constraints: [
                   searchTableView.topAnchor.constraint(equalTo: safe().topAnchor),
                   searchTableView.bottomAnchor.constraint(equalTo: safe().bottomAnchor, constant: 0),
                   searchTableView.leadingAnchor.constraint(equalTo: safe().leadingAnchor, constant: 0),
                   searchTableView.trailingAnchor.constraint(equalTo: safe().trailingAnchor, constant: 0)
               ])

        searchTableView.rowHeight = UITableView.automaticDimension
        searchTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "cell")
        searchTableView.estimatedRowHeight = 20

    }

    func setUpSpinner(){
        spinner.addCodeConstraints(parentView: self, constraints: [
                   spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                   spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor)
               ])
               spinner.color = .blue
               spinner.isHidden = true
    }

    func setUpPopularLabel(){
        popularsSearchLabel.addCodeConstraints(parentView: self, constraints: [
            popularsSearchLabel.topAnchor.constraint(equalTo: safe().topAnchor, constant: 70),
            popularsSearchLabel.centerXAnchor.constraint(equalTo: safe().centerXAnchor)

        ])

        popularsSearchLabel.text = "Popular Search"
    
        popularsSearchLabel.textAlignment = .center
    }

    func setUpPopularStackView(){
        popularSearchStackView.addCodeConstraints(parentView: self, constraints: [
            popularSearchStackView.topAnchor.constraint(equalTo: popularsSearchLabel.bottomAnchor, constant: 10),
            popularSearchStackView.centerXAnchor.constraint(equalTo: safe().centerXAnchor)
        ])

        popularSearchStackView.axis = .vertical
        popularSearchStackView.distribution = .equalSpacing
        popularSearchStackView.alignment = .center
        popularSearchStackView.spacing = 15
    }

}
