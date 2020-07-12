//
//  DetailClipView.swift
//  Clippy
//
//  Created by Ryan Gunn on 6/15/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import UIKit
import TTGTagCollectionView
@IBDesignable class DetailClipView: UIView {

     let playerContainerView = UIView()
      let clipTitleLabel = UILabel()
      let shareButton = UIButton()
      var tagCollectionView = TTGTextTagCollectionView()
    let downloadButton = UIButton()
    let clipUserLabel = UILabel()
    let clipInfoView = UIView()
    let clipDateTextLabel = UILabel()
    let playerOverlay = UIView()
    let playButton = UIButton()
    let rewindButton = UIButton()
    let fullScreenButton = UIButton()
    let buttonStackView = UIStackView()
    let favButton = UIButton()


      override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setUpDetailView()
      }

    override func prepareForInterfaceBuilder() {
        setUpDetailView()
        clipTitleLabel.text = "Stephen a smith we don't care"
        clipUserLabel.text = "Created by Test"
        clipDateTextLabel.text = "Date CREATEd = June 23,2020"
       
    }

    func setUpDetailView(){
        self.backgroundColor =  UIColor(red: 253.0/255.0, green: 33.0/255.0, blue: 33.0/250.0, alpha:1.0 )
    setUpPlayerContainerView()
        setUpPlayerOverlay()
        setUpPlayButton()
        setUpRewindButton()
        setUpFullScreenButton()
         setUpClipTitleLabel()
        setUpButtonStackView()
        addClipInfoView()
        setUpUserLabel()
        setUDateLabel()
        setUpTagCollectionView()
           //setUpShareButton()
//         setUpDownloadButton()
           //setUpTagCollectionView()
    }

    func bindClip(clip:ClipWithID){
        clipTitleLabel.text = clip.title
        clipDateTextLabel.text = "DATE CERATED: \(clip.convertCreatedDateToString())"
        clipUserLabel.text = "CREATED BY: \(clip.user)"
        if let tags = clip.tags {
             tagCollectionView.addTags(tags)
        }

    }

      required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
      }

      private func setUpPlayerContainerView(){
          playerContainerView.backgroundColor = .white
          playerContainerView.addCodeConstraints(parentView: self, constraints: [
              playerContainerView.leadingAnchor.constraint(equalTo: safe().leadingAnchor,constant: 30),
              playerContainerView.trailingAnchor.constraint(equalTo: safe().trailingAnchor,constant: -30),
              playerContainerView.topAnchor.constraint(equalTo: safe().topAnchor, constant: 30),
              playerContainerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3)
          ])
      }

    private func setUpPlayerOverlay(){
        playerOverlay.backgroundColor = .black
        playerOverlay.alpha = 0.5
        playerOverlay.isHidden = true
        playerOverlay.addCodeConstraints(parentView: playerContainerView, constraints: [
            playerOverlay.topAnchor.constraint(equalTo: playerContainerView.topAnchor),
            playerOverlay.bottomAnchor.constraint(equalTo: playerContainerView.bottomAnchor),
            playerOverlay.leadingAnchor.constraint(equalTo: playerContainerView.leadingAnchor),
            playerOverlay.trailingAnchor.constraint(equalTo: playerContainerView.trailingAnchor)
        ])
    }

    private func setUpPlayButton(){
        playButton.setImage(UIImage(named: "play"), for: .normal)
        playButton.addCodeConstraints(parentView: playerOverlay, constraints: [
            playButton.centerXAnchor.constraint(equalTo: playerOverlay.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: playerOverlay.centerYAnchor),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            playButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setUpRewindButton(){
        rewindButton.setImage(UIImage(named: "rewind"), for: .normal)
        rewindButton.addCodeConstraints(parentView: playerOverlay, constraints: [
            rewindButton.centerYAnchor.constraint(equalTo: playerOverlay.centerYAnchor),
            rewindButton.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -60),
            rewindButton.heightAnchor.constraint(equalToConstant: 50),
            rewindButton.widthAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func setUpFullScreenButton(){
        fullScreenButton.setImage(UIImage(named: "fullscreen"), for: .normal)
        fullScreenButton.addCodeConstraints(parentView: playerOverlay, constraints: [
            fullScreenButton.bottomAnchor.constraint(equalTo: playerOverlay.bottomAnchor, constant: -5),
            fullScreenButton.trailingAnchor.constraint(equalTo: playerOverlay.trailingAnchor, constant: -10),
            fullScreenButton.heightAnchor.constraint(equalToConstant: 20),
            fullScreenButton.widthAnchor.constraint(equalToConstant: 20)
        ])
    }


    private func setUpClipTitleLabel(){
        clipTitleLabel.addCodeConstraints(parentView: self, constraints: [
            clipTitleLabel.topAnchor.constraint(equalTo: playerContainerView.bottomAnchor, constant: 15),
            clipTitleLabel.centerXAnchor.constraint(equalTo: playerContainerView.centerXAnchor)
        ])

        clipTitleLabel.textAlignment = .center
        clipTitleLabel.numberOfLines = 0
        clipTitleLabel.lineBreakMode = .byWordWrapping
    }

    private func setUpButtonStackView(){
        buttonStackView.addCodeConstraints(parentView: self, constraints: [
            buttonStackView.leadingAnchor.constraint(equalTo: playerContainerView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: playerContainerView.trailingAnchor),
            buttonStackView.topAnchor.constraint(equalTo: clipTitleLabel.bottomAnchor,constant: 10)
        ])

        buttonStackView.axis = .horizontal

        shareButton.setTitle("Share", for: .normal)
        shareButton.setTitleColor(.blue, for: .normal)
        downloadButton.setTitle("Download", for: .normal)
        downloadButton.setTitleColor(.blue, for: .normal)
        favButton.setTitle("Fav", for: .normal)
        favButton.setTitleColor(.blue, for: .normal)
        buttonStackView.addArrangedSubview(shareButton)
        buttonStackView.addArrangedSubview(downloadButton)
        buttonStackView.addArrangedSubview(favButton)
        buttonStackView.distribution = .fillEqually
    }



    private func addClipInfoView(){
        clipInfoView.backgroundColor = .white
        clipInfoView.addCodeConstraints(parentView: self, constraints: [
            clipInfoView.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 30),
            clipInfoView.leadingAnchor.constraint(equalTo: safe().leadingAnchor, constant: 15),
            clipInfoView.trailingAnchor.constraint(equalTo: safe().trailingAnchor, constant: -15),

        ])
    }

    private func setUpUserLabel(){
        clipUserLabel.addCodeConstraints(parentView: clipInfoView, constraints: [
            clipUserLabel.topAnchor.constraint(equalTo: clipInfoView.topAnchor, constant: 20),
            clipUserLabel.leadingAnchor.constraint(equalTo: clipInfoView.leadingAnchor,constant: 10),
            clipUserLabel.trailingAnchor.constraint(equalTo: clipInfoView.trailingAnchor,constant: -10)
        ])
        clipUserLabel.textAlignment = .center
    }

    private func setUDateLabel(){
        clipDateTextLabel.addCodeConstraints(parentView: clipInfoView, constraints: [
            clipDateTextLabel.topAnchor.constraint(lessThanOrEqualTo: clipUserLabel.bottomAnchor, constant: 3),
            clipDateTextLabel.leadingAnchor.constraint(equalTo: clipUserLabel.leadingAnchor),
            clipDateTextLabel.trailingAnchor.constraint(equalTo: clipUserLabel.trailingAnchor)
        ])
        clipDateTextLabel.textAlignment = .center

    }

    private func setUpTagCollectionView(){
        let flowLayout = UICollectionViewFlowLayout()

        flowLayout.scrollDirection = .horizontal

                flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//                tagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
//                tagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        tagCollectionView.addCodeConstraints(parentView: clipInfoView, constraints: [
             tagCollectionView.topAnchor.constraint(equalTo: clipDateTextLabel.bottomAnchor, constant: 10),
                       tagCollectionView.leadingAnchor.constraint(equalTo: clipInfoView.leadingAnchor,constant: 5),
                       tagCollectionView.trailingAnchor.constraint(equalTo: clipInfoView.trailingAnchor,constant: -5),
                       tagCollectionView.bottomAnchor.constraint(equalTo: clipInfoView.bottomAnchor, constant: -20)
        ])

        let height = tagCollectionView.heightAnchor.constraint(equalToConstant: 40)
        height.priority = .defaultHigh
        height.isActive = true

        tagCollectionView.scrollDirection = .horizontal
        tagCollectionView.numberOfLines = 1
//        tagCollectionView.isPagingEnabled = true
//        tagCollectionView.isScrollEnabled = true
        tagCollectionView.backgroundColor = .clear

        //clipTagsLabel.textAlignment = .center
//       clipInfoView.bottomAnchor.constraint(equalTo: clipTagsLabel.bottomAnchor, constant: -20).isActive = true
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


}
