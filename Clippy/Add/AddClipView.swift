//
//  HomeView.swift
//  Clippy
//
//  Created by Ryan Gunn on 6/6/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import UIKit
import TTGTagCollectionView
import UITextView_Placeholder

@IBDesignable class AddClipView: UIView {

    let playerContainerView = UIView()
    let selectVideoButton = UIButton()
    let addTitleTextView = UITextView()
    let addTagTextView = UITextView()
    let saveButton = UIButton()
    var tagCollectionView = TTGTextTagCollectionView()
    let editButton = UIButton()
    let categoryTextView = UITextView()

    override init(frame: CGRect) {
      super.init(frame: frame)
        setUpPlayerContainerView()
        setUpSelectVideoButton()
        setUpSaveButton()
        setUpEditButton()
        setUpAddTitleTextView()
        setUpAddCategoryTextView()
        setUpAddTagTextView()
        setUpTagCollectionView()
        
    }

    override func prepareForInterfaceBuilder() {
        setUpPlayerContainerView()
            setUpSelectVideoButton()
            setUpSaveButton()
            setUpEditButton()
            setUpAddTitleTextView()
            setUpAddTagTextView()
            setUpTagCollectionView()
    }



    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }

    func setGradientBackground() {
        let colorTop =  UIColor.white.cgColor
        let colorBottom = UIColor.red.cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds

        self.layer.insertSublayer(gradientLayer, at:0)
    }
    
    private func setUpPlayerContainerView(){
        playerContainerView.backgroundColor = .white
        playerContainerView.addCodeConstraints(parentView: self, constraints: [
            playerContainerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 30),
            playerContainerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,constant: -30),
            playerContainerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30),
            playerContainerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4)
        ])
    }

    private func setUpSelectVideoButton(){
        selectVideoButton.setTitle("Select Video", for: .normal)
        selectVideoButton.setTitleColor(.blue, for: .normal)
        selectVideoButton.addCodeConstraints(parentView: self, constraints: [
            selectVideoButton.topAnchor.constraint(equalTo: playerContainerView.bottomAnchor, constant: 8),
            selectVideoButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    private func setUpSaveButton(){
          saveButton.setTitle("Save", for: .normal)
          saveButton.setTitleColor(.blue, for: .normal)
          saveButton.addCodeConstraints(parentView: self, constraints: [
            saveButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -50),
              saveButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
          ])
        saveButton.isHidden = true
      }

    private func setUpEditButton(){
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.blue, for: .normal)
        editButton.addCodeConstraints(parentView: self, constraints: [
            editButton.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -10),
            editButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])

        editButton.isHidden = true
    }

    private func setUpAddTitleTextView(){
        addTitleTextView.returnKeyType = UIReturnKeyType.done
        addTitleTextView.addCodeConstraints(parentView: self, constraints: [
            addTitleTextView.topAnchor.constraint(equalTo: selectVideoButton.bottomAnchor, constant: 10),
            addTitleTextView.heightAnchor.constraint(equalToConstant: 40),
            addTitleTextView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 30),
            addTitleTextView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        addTitleTextView.placeholder = "Add Title"
        addTitleTextView.placeholderColor = .gray
        addTitleTextView.textColor = .black
    }

    private func setUpAddCategoryTextView(){

        categoryTextView.textColor = .black
         categoryTextView.addCodeConstraints(parentView: self, constraints: [
             categoryTextView.topAnchor.constraint(equalTo: addTitleTextView.bottomAnchor, constant: 10),
             categoryTextView.heightAnchor.constraint(equalToConstant: 40),
             categoryTextView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 30),
             categoryTextView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30)
         ])
       categoryTextView.placeholder = "Add Category to clip"
        addTagTextView.placeholderColor = .gray
     }

    private func setUpAddTagTextView(){
        addTagTextView.backgroundColor = .lightGray
        addTagTextView.textColor = .black
        addTagTextView.returnKeyType = UIReturnKeyType.done
         addTagTextView.addCodeConstraints(parentView: self, constraints: [
             addTagTextView.topAnchor.constraint(equalTo: categoryTextView.bottomAnchor, constant: 10),
             addTagTextView.heightAnchor.constraint(equalToConstant: 40),
             addTagTextView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 30),
             addTagTextView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30)
         ])
        addTagTextView.placeholder = "Add Tags to clip"
        addTagTextView.placeholderColor = .gray
     }

    private func setUpTagCollectionView(){
        tagCollectionView.addCodeConstraints(parentView: self, constraints: [
            tagCollectionView.topAnchor.constraint(equalTo: addTagTextView.bottomAnchor, constant: 10),
            tagCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            tagCollectionView.trailingAnchor.constraint(equalTo: safe().trailingAnchor, constant: -20),
            tagCollectionView.bottomAnchor.constraint(equalTo: editButton.topAnchor, constant: -10)
        ])

         let height = tagCollectionView.heightAnchor.constraint(equalToConstant: 40)
            height.priority = .defaultHigh
            height.isActive = true
            tagCollectionView.scrollDirection = .horizontal
            tagCollectionView.numberOfLines = 1
            tagCollectionView.backgroundColor = .clear
    }

    

}
