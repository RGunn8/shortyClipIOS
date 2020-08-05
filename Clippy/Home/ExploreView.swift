//
//  ExploreView.swift
//  Clippy
//
//  Created by Ryan Gunn on 7/14/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import UIKit

class ExploreView: UIView {
    let topBarView = TopBarView()
    let categoriesBackground = UIView()
       let categoriesLabel = UILabel()
    let clipsTableView = UITableView()
    let  subTitleLabel = UILabel()

    
    override init(frame: CGRect) {
           super.init(frame: frame)
           self.backgroundColor = UIColor.white
               //setUpHomeView()
        setUpTopView()
        setExploreBackground()
        setUpExploreLabel()
        setupClipsTableView()
        setupSubTitleabel()
         }

//         override func prepareForInterfaceBuilder() {
//               setUpHomeView()
//         }
         required init?(coder aDecoder: NSCoder) {
               super.init(coder: aDecoder)
             }

    func setUpTopView(){
           topBarView.addCodeConstraints(parentView: self, constraints: [
               topBarView.topAnchor.constraint(equalTo: safe().topAnchor),
               topBarView.leadingAnchor.constraint(equalTo: safe().leadingAnchor),
               topBarView.trailingAnchor.constraint(equalTo: safe().trailingAnchor)
           ])
       }

       func setExploreBackground(){
           categoriesBackground.addCodeConstraints(parentView: self, constraints: [
               categoriesBackground.topAnchor.constraint(equalTo: topBarView.newClipBackground.bottomAnchor, constant: 1),
               categoriesBackground.leadingAnchor.constraint(equalTo: safe().leadingAnchor),
               categoriesBackground.trailingAnchor.constraint(equalTo: safe().trailingAnchor),
               categoriesBackground.heightAnchor.constraint(equalToConstant: 70)
           ])
           categoriesBackground.backgroundColor = .electricPurple
       }

    func setupSubTitleabel(){
     subTitleLabel.addCodeConstraints(parentView: categoriesBackground , constraints: [
                subTitleLabel.leadingAnchor.constraint(equalTo: categoriesLabel.leadingAnchor),
                subTitleLabel.topAnchor.constraint(equalTo: categoriesLabel.bottomAnchor, constant: 1)
            ])

            
                 subTitleLabel.textColor = .white
            subTitleLabel.font = subTitleLabel.font.withSize(15)
     }


       func setUpExploreLabel(){
           categoriesLabel.addCodeConstraints(parentView: categoriesBackground, constraints: [
                      categoriesLabel.leadingAnchor.constraint(equalTo: categoriesBackground.leadingAnchor,constant: 5),
                      categoriesLabel.topAnchor.constraint(equalTo: categoriesBackground.topAnchor, constant: 5)
                  ])

                  categoriesLabel.text = "<< Categories"
                  categoriesLabel.textColor = .white
                  categoriesLabel.alpha = 0.5
           categoriesLabel.font = categoriesLabel.font.withSize(35)
       }

    func setupClipsTableView(){
        clipsTableView.addCodeConstraints(parentView: self, constraints: [
            clipsTableView.topAnchor.constraint(equalTo: categoriesBackground.bottomAnchor),
                   clipsTableView.bottomAnchor.constraint(equalTo: safe().bottomAnchor, constant: 0),
                   clipsTableView.leadingAnchor.constraint(equalTo: safe().leadingAnchor, constant: 0),
                   clipsTableView.trailingAnchor.constraint(equalTo: safe().trailingAnchor, constant: 0)
               ])
               clipsTableView.rowHeight = UITableView.automaticDimension
               clipsTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "cell")
               clipsTableView.estimatedRowHeight = 200
    }


}
