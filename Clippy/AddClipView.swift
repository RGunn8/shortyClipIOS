//
//  HomeView.swift
//  Clippy
//
//  Created by Ryan Gunn on 6/6/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import UIKit

class AddClipView: UIView {

    let playerContainerView = UIView()
    let selectVideoButton = UIButton()
    let addTitleTextView = UITextView()
    let addTagTextView = UITextView()
    let saveButton = UIButton()
    var tagCollectionView:UICollectionView!
    let editButton = UIButton()

    override init(frame: CGRect) {
      super.init(frame: frame)
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

    private func setUpPlayerContainerView(){
        playerContainerView.backgroundColor = .clear
        playerContainerView.addCodeConstraints(parentView: self, constraints: [
            playerContainerView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 30),
            playerContainerView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,constant: -30),
            playerContainerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30),
            playerContainerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3)
        ])
    }

    private func setUpSelectVideoButton(){
        selectVideoButton.setTitle("Select Video", for: .normal)
        selectVideoButton.setTitleColor(.blue, for: .normal)
        selectVideoButton.addCodeConstraints(parentView: self, constraints: [
            selectVideoButton.topAnchor.constraint(equalTo: playerContainerView.bottomAnchor, constant: 15),
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
      }

    private func setUpEditButton(){
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.blue, for: .normal)
        editButton.addCodeConstraints(parentView: self, constraints: [
            editButton.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -10),
            editButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    private func setUpAddTitleTextView(){

        addTitleTextView.addCodeConstraints(parentView: self, constraints: [
            addTitleTextView.topAnchor.constraint(equalTo: selectVideoButton.bottomAnchor, constant: 20),
            addTitleTextView.heightAnchor.constraint(equalToConstant: 40),
            addTitleTextView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 30),
            addTitleTextView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
    }

    private func setUpAddTagTextView(){
        addTagTextView.backgroundColor = .lightGray
        addTagTextView.textColor = .black
         addTagTextView.addCodeConstraints(parentView: self, constraints: [
             addTagTextView.topAnchor.constraint(equalTo: addTitleTextView.bottomAnchor, constant: 10),
             addTagTextView.heightAnchor.constraint(equalToConstant: 40),
             addTagTextView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 30),
             addTagTextView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -30)
         ])
     }

    private func setUpTagCollectionView(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        tagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        tagCollectionView.addCodeConstraints(parentView: self, constraints: [
            tagCollectionView.topAnchor.constraint(equalTo: addTagTextView.bottomAnchor, constant: 10),
            tagCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 20),
            tagCollectionView.trailingAnchor.constraint(equalTo: safe().trailingAnchor, constant: -20),
            tagCollectionView.bottomAnchor.constraint(equalTo: editButton.topAnchor, constant: -10)
        ])
    }

}
