//
//  DetailClipView.swift
//  Clippy
//
//  Created by Ryan Gunn on 6/15/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import UIKit

class DetailClipView: UIView {

     let playerContainerView = UIView()
      let clipTitleLabel = UILabel()
      let shareButton = UIButton()
      var tagCollectionView:UICollectionView!
    let downloadButton = UIButton()

      override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
          setUpPlayerContainerView()
        setUpClipTitleLabel()
          setUpShareButton()
        setUpDownloadButton()
          setUpTagCollectionView()
      }

      required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      }

      private func setUpPlayerContainerView(){
          playerContainerView.backgroundColor = .clear
          playerContainerView.addCodeConstraints(parentView: self, constraints: [
              playerContainerView.leadingAnchor.constraint(equalTo: safe().leadingAnchor,constant: 30),
              playerContainerView.trailingAnchor.constraint(equalTo: safe().trailingAnchor,constant: -30),
              playerContainerView.topAnchor.constraint(equalTo: safe().topAnchor, constant: 30),
              playerContainerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3)
          ])
      }


    private func setUpClipTitleLabel(){
        clipTitleLabel.addCodeConstraints(parentView: self, constraints: [
            clipTitleLabel.topAnchor.constraint(equalTo: playerContainerView.bottomAnchor, constant: 15),
            clipTitleLabel.centerXAnchor.constraint(equalTo: playerContainerView.centerXAnchor)
        ])
    }


      private func setUpShareButton(){
            shareButton.setTitle("Share", for: .normal)
            shareButton.setTitleColor(.blue, for: .normal)
            shareButton.addCodeConstraints(parentView: self, constraints: [
              shareButton.bottomAnchor.constraint(equalTo: safe().bottomAnchor, constant: -50),
                shareButton.centerXAnchor.constraint(equalTo: safe().centerXAnchor)
            ])
        }

    private func setUpDownloadButton(){
            downloadButton.setTitle("Download", for: .normal)
           downloadButton.setTitleColor(.blue, for: .normal)
            downloadButton.addCodeConstraints(parentView: self, constraints: [
                downloadButton.topAnchor.constraint(equalTo: shareButton.bottomAnchor, constant: 5),
                downloadButton.centerXAnchor.constraint(equalTo: safe().centerXAnchor)
            ])
        }

      private func setUpTagCollectionView(){
          let flowLayout = UICollectionViewFlowLayout()
          flowLayout.scrollDirection = .vertical

          flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
          tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
          tagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
          tagCollectionView.addCodeConstraints(parentView: self, constraints: [
              tagCollectionView.topAnchor.constraint(equalTo: clipTitleLabel.bottomAnchor, constant: 10),
              tagCollectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 20),
              tagCollectionView.trailingAnchor.constraint(equalTo: safe().trailingAnchor, constant: -20),
              tagCollectionView.bottomAnchor.constraint(equalTo: shareButton.topAnchor, constant: -10)
          ])
         tagCollectionView.backgroundColor = UIColor.white
      }

}
