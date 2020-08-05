//
//  TopBarView.swift
//  Clippy
//
//  Created by Ryan Gunn on 7/14/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import UIKit

@IBDesignable class TopBarView: UIView {

    let searchLabel = UILabel()
    let newClipLabel = UILabel()
    let searchBackground = UIView()
    let newClipBackground = UIView()

    override init(frame: CGRect) {
      super.init(frame: frame)
      self.backgroundColor = UIColor.white
        setUpSeachBackground()
        setUpNewClipBackground()

    }

    override func prepareForInterfaceBuilder() {
        setUpSeachBackground()
        setUpNewClipBackground()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    func setUpSeachBackground(){
        searchBackground.addCodeConstraints(parentView: self, constraints: [
                  searchBackground.leadingAnchor.constraint(equalTo: safe().leadingAnchor),
                  searchBackground.trailingAnchor.constraint(equalTo: safe().centerXAnchor, constant: -1),
                  searchBackground.topAnchor.constraint(equalTo: safe().topAnchor),
                  searchBackground.heightAnchor.constraint(equalToConstant: 50)
              ])
        searchBackground.backgroundColor = .oxfordBlue

        searchLabel.addCodeConstraints(parentView: searchBackground, constraints: [
            searchLabel.centerXAnchor.constraint(equalTo: searchBackground.centerXAnchor),
            searchLabel.centerYAnchor.constraint(equalTo: searchBackground.centerYAnchor)
        ])

        searchLabel.textColor = .white
        searchLabel.text = "Search"

    }

    func setUpNewClipBackground(){

            newClipBackground.addCodeConstraints(parentView: self, constraints: [
                      newClipBackground.leadingAnchor.constraint(equalTo: safe().centerXAnchor,constant: 2),
                      newClipBackground.trailingAnchor.constraint(equalTo: safe().trailingAnchor),
                      newClipBackground.topAnchor.constraint(equalTo: safe().topAnchor),
                      newClipBackground.heightAnchor.constraint(equalToConstant: 50)
                  ])
            newClipBackground.backgroundColor = .oxfordBlue

           newClipLabel.addCodeConstraints(parentView: newClipBackground, constraints: [
                newClipLabel.centerXAnchor.constraint(equalTo: newClipBackground.centerXAnchor),
                newClipLabel.centerYAnchor.constraint(equalTo: newClipBackground.centerYAnchor)
            ])

            newClipLabel.textColor = .white
            newClipLabel.text = "New Clip"

    }



}
