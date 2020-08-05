//
//  HomeView.swift
//  Clippy
//
//  Created by Ryan Gunn on 7/14/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import UIKit
import TTGTagCollectionView
import AVFoundation

@IBDesignable class HomeView: UIView {
    let topBarView = TopBarView()
    let exploreBackground = UIView()
    let exploreLabel = UILabel()
    let swipeRightLabel = UILabel()
    var clipPreviewImageView = UIImageView()
     var tagCollectionView = TTGTextTagCollectionView()
    var clipTitleLabel = UILabel()
    var favoriteImageView = UIImageView()
    var favoriteLabel = UILabel()
    let categoriesLabel = UILabel()
    let categoriesBackground = UIView()
    let categoriesTableView = UITableView()
   let  clipDurationLabel = UILabel()
   override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
            setUpHomeView()
      }

      override func prepareForInterfaceBuilder() {
            setUpHomeView()
      }
      required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
          }

    func setUpHomeView(){
        setUpTopView()
       setExploreBackground()
        setUpExploreLabel()
        setUpSwipeRightLabel()
        setUpClipImageView()
        setupFavoriteLabel()
        setUpFavoriteImageView()
        setUpClipTitle()
        setUpTagCollectionView()
        setupCategoriesBackground()
        setupCategoriesLabel()
        setupCategoryTableView()
    }

    func bindClip(clip:ClipWithID){
        clipTitleLabel.text = clip.title
        tagCollectionView.addTags(clip.getTagLabel())
         clipPreviewImageView.contentMode = .scaleAspectFill
                clipPreviewImageView.clipsToBounds = true
                setDurationLabel(duration: clip.duration)
                DispatchQueue.global(qos: .background).async {
                    let image =  self.getFirstFrameOfVideo(url: clip.clipURL)
                    DispatchQueue.main.async {
                        self.clipPreviewImageView.image = image
                    }
                }
    }



    private func setDurationLabel(duration:Int){
         if duration < 10 {
             clipDurationLabel.text = "0:0\(duration)"
         }else{
             clipDurationLabel.text = "0:\(duration)"
         }
     }

    func getFirstFrameOfVideo(url:String) -> UIImage?{

              let asset = AVURLAsset(url: URL(string: url)!, options: nil)
                 let imgGenerator = AVAssetImageGenerator(asset: asset)
           imgGenerator.appliesPreferredTrackTransform = true
              do{
                  let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
                  return UIImage(cgImage: cgImage)
              }catch let err{
                  print(err)
              }
              return nil

          }

    func setUpTopView(){
        topBarView.addCodeConstraints(parentView: self, constraints: [
            topBarView.topAnchor.constraint(equalTo: safe().topAnchor),
            topBarView.leadingAnchor.constraint(equalTo: safe().leadingAnchor),
            topBarView.trailingAnchor.constraint(equalTo: safe().trailingAnchor)
        ])
    }

    func setExploreBackground(){
        exploreBackground.addCodeConstraints(parentView: self, constraints: [
            exploreBackground.topAnchor.constraint(equalTo: topBarView.newClipBackground.bottomAnchor, constant: 1),
            exploreBackground.leadingAnchor.constraint(equalTo: safe().leadingAnchor),
            exploreBackground.trailingAnchor.constraint(equalTo: safe().trailingAnchor),
            exploreBackground.heightAnchor.constraint(equalToConstant: 70)
        ])
        exploreBackground.backgroundColor = .electricPurple
    }

    func setUpExploreLabel(){
        exploreLabel.addCodeConstraints(parentView: exploreBackground, constraints: [
                   exploreLabel.leadingAnchor.constraint(equalTo: exploreBackground.leadingAnchor,constant: 5),
                   exploreLabel.topAnchor.constraint(equalTo: exploreBackground.topAnchor, constant: 5)
               ])

               exploreLabel.text = "Explore >>"
               exploreLabel.textColor = .white
               exploreLabel.alpha = 0.5
        
        exploreLabel.font = exploreLabel.font.withSize(35)
    }

    func setUpSwipeRightLabel(){
    swipeRightLabel.addCodeConstraints(parentView: exploreBackground, constraints: [
               swipeRightLabel.leadingAnchor.constraint(equalTo: exploreLabel.leadingAnchor),
               swipeRightLabel.topAnchor.constraint(equalTo: exploreLabel.bottomAnchor, constant: 1)
           ])

           swipeRightLabel.text = "swipe right"
                swipeRightLabel.textColor = .white
           swipeRightLabel.font = exploreLabel.font.withSize(15)
    }

    func setUpClipImageView(){
        clipPreviewImageView.addCodeConstraints(parentView: self, constraints: [
            clipPreviewImageView.topAnchor.constraint(equalTo: exploreBackground.bottomAnchor),
            clipPreviewImageView.leadingAnchor.constraint(equalTo: safe().leadingAnchor),
            clipPreviewImageView.trailingAnchor.constraint(equalTo: safe().trailingAnchor),
            clipPreviewImageView.heightAnchor.constraint(equalToConstant: 200)
        ])

        clipPreviewImageView.backgroundColor = .red
        clipDurationLabel.addCodeConstraints(parentView: clipPreviewImageView, constraints: [
                 clipDurationLabel.bottomAnchor.constraint(equalTo: clipPreviewImageView.bottomAnchor,constant: -10),
                 clipDurationLabel.trailingAnchor.constraint(equalTo: clipPreviewImageView.trailingAnchor,constant: -10)
             ])

        clipDurationLabel.backgroundColor = .black
              clipDurationLabel.textColor = .white
        clipPreviewImageView.contentMode = .scaleAspectFit
    }

    func setupFavoriteLabel(){
        favoriteLabel.addCodeConstraints(parentView: self, constraints:[
            favoriteLabel.topAnchor.constraint(equalTo: clipPreviewImageView.bottomAnchor,constant: 3),
            favoriteLabel.trailingAnchor.constraint(equalTo: safe().trailingAnchor, constant: -5)
        ])
        favoriteLabel.text = "0"
    }

    func setUpFavoriteImageView(){
        favoriteImageView.addCodeConstraints(parentView: self, constraints: [
            favoriteImageView.trailingAnchor.constraint(equalTo: favoriteLabel.leadingAnchor, constant: -3),
            favoriteImageView.topAnchor.constraint(equalTo: favoriteLabel.topAnchor),
            favoriteImageView.widthAnchor.constraint(equalToConstant: 10),
            favoriteImageView.heightAnchor.constraint(equalToConstant: 10)
        ])

        favoriteImageView.backgroundColor = .black
    }

    func setUpClipTitle(){
        clipTitleLabel.addCodeConstraints(parentView: self, constraints: [
            clipTitleLabel.topAnchor.constraint(equalTo: clipPreviewImageView.bottomAnchor, constant: 3),
            clipTitleLabel.leadingAnchor.constraint(equalTo: safe().leadingAnchor, constant: 5),
            clipTitleLabel.trailingAnchor.constraint(equalTo: favoriteImageView.leadingAnchor,constant: -3)
        ])

        clipTitleLabel.numberOfLines = 0

        clipTitleLabel.text = "Rick and Morty"
    }

    func setUpTagCollectionView(){
        tagCollectionView.addCodeConstraints(parentView: self, constraints: [
                     tagCollectionView.topAnchor.constraint(equalTo: clipTitleLabel.bottomAnchor, constant: 5),
                               tagCollectionView.leadingAnchor.constraint(equalTo: clipTitleLabel.leadingAnchor),
                               tagCollectionView.trailingAnchor.constraint(equalTo: safe().trailingAnchor,constant: -5),
                ])

                let height = tagCollectionView.heightAnchor.constraint(equalToConstant: 30)
                height.priority = .defaultHigh
                height.isActive = true

        tagCollectionView.scrollDirection = .horizontal
        tagCollectionView.numberOfLines = 1
        tagCollectionView.horizontalSpacing = 2
        tagCollectionView.backgroundColor = .clear
        let config = TTGTextTagConfig()
        config.backgroundColor = .white
        config.shadowColor = .white
        config.textColor = .black
        config.textFont = UIFont.systemFont(ofSize: 10)
        tagCollectionView.defaultConfig = config
    }


    func setupCategoriesBackground(){
        categoriesBackground.addCodeConstraints(parentView: self, constraints: [
            categoriesBackground.topAnchor.constraint(equalTo: tagCollectionView.bottomAnchor, constant: 8),
            categoriesBackground.leadingAnchor.constraint(equalTo: safe().leadingAnchor),
            categoriesBackground.trailingAnchor.constraint(equalTo: safe().trailingAnchor),
            categoriesBackground.heightAnchor.constraint(equalToConstant: 70)
        ])
        categoriesBackground.backgroundColor = .vividSkyBlue
    }

    func setupCategoriesLabel(){
          categoriesLabel.addCodeConstraints(parentView: categoriesBackground, constraints: [
                     categoriesLabel.leadingAnchor.constraint(equalTo: categoriesBackground.leadingAnchor,constant: 5),
                     categoriesLabel.centerYAnchor.constraint(equalTo: categoriesBackground.centerYAnchor)
                 ])

                 categoriesLabel.text = "Categories"
                 categoriesLabel.textColor = .white
                 categoriesLabel.alpha = 0.5
          categoriesLabel.font = categoriesLabel.font.withSize(35)
      }

    func setupCategoryTableView(){
        categoriesTableView.addCodeConstraints(parentView: self, constraints: [
            categoriesTableView.topAnchor.constraint(equalTo: categoriesBackground.bottomAnchor),
            categoriesTableView.leadingAnchor.constraint(equalTo: safe().leadingAnchor),
            categoriesTableView.trailingAnchor.constraint(equalTo: safe().trailingAnchor),
            categoriesTableView.bottomAnchor.constraint(equalTo: safe().bottomAnchor)
        ])

        categoriesTableView.rowHeight = UITableView.automaticDimension
        categoriesTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "cell")
        categoriesTableView.estimatedRowHeight = 50
    }

}
