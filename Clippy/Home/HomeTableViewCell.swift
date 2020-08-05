//
//  HomeTableViewCell.swift
//  Clippy
//
//  Created by Ryan Gunn on 6/14/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import UIKit
import AVFoundation

class HomeTableViewCell: UITableViewCell {

    let clipPreviewImageView = UIImageView()
    let clipTitleLabel = UILabel()
    let clipUserNameLabel = UILabel()
    var playerLayer = AVPlayerLayer()
    let clipDurationLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        clipPreviewImageView.addCodeConstraints(parentView: self, constraints: [
            clipPreviewImageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,constant: 10),
            clipPreviewImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            clipPreviewImageView.trailingAnchor.constraint(equalTo: safe().trailingAnchor,constant: -10),
//            clipPreviewImageView.bottomAnchor.con
        ])
        clipPreviewImageView.backgroundColor = .blue
        self.backgroundColor = UIColor.clear
        let constraint = clipPreviewImageView.heightAnchor.constraint(equalToConstant: 200)
        constraint.priority = .defaultHigh
        constraint.isActive = true

        clipDurationLabel.addCodeConstraints(parentView: clipPreviewImageView, constraints: [
            clipDurationLabel.bottomAnchor.constraint(equalTo: clipPreviewImageView.bottomAnchor,constant: -10),
            clipDurationLabel.trailingAnchor.constraint(equalTo: clipPreviewImageView.trailingAnchor,constant: -10)

        ])

        clipDurationLabel.backgroundColor = .black
        clipDurationLabel.textColor = .white

        clipTitleLabel.addCodeConstraints(parentView: self, constraints: [
            clipTitleLabel.centerXAnchor.constraint(equalTo: clipPreviewImageView.centerXAnchor),
            clipTitleLabel.topAnchor.constraint(equalTo: clipPreviewImageView.bottomAnchor, constant: 10),
            clipTitleLabel.leadingAnchor.constraint(equalTo: safe().leadingAnchor,constant: 10),
            clipTitleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            //clipTitleLabel.bottomAnchor.constraint(equalTo: safe().bottomAnchor,constant: -10)
        ])

        clipTitleLabel.textAlignment = .center
        clipTitleLabel.numberOfLines = 0
        clipTitleLabel.lineBreakMode = .byWordWrapping


        clipUserNameLabel.addCodeConstraints(parentView: self, constraints: [
            clipUserNameLabel.topAnchor.constraint(equalTo: clipTitleLabel.bottomAnchor, constant: 10),
            clipUserNameLabel.centerXAnchor.constraint(equalTo: clipTitleLabel.centerXAnchor),
            clipUserNameLabel.bottomAnchor.constraint(equalTo: safe().bottomAnchor,constant: -15)

        ])
        clipUserNameLabel.textAlignment = .center

    }

    func bindCell(clip:ClipWithID){
        self.clipUserNameLabel.text = clip.user
        self.clipTitleLabel.text = clip.title
        clipPreviewImageView.contentMode = .scaleAspectFill
        clipPreviewImageView.clipsToBounds = true
        setDurationLabel(duration: clip.duration)
//        playerLayer.videoGravity = .resizeAspectFill
//        clipPreviewImageView.layoutIfNeeded()
//        playerLayer.frame = clipPreviewImageView.bounds
//        clipPreviewImageView.layer.addSublayer(playerLayer)
//        playerLayer.player = AVPlayer(url: URL(string: clip.clipURL)!)
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

    override func prepareForReuse() {
        self.clipPreviewImageView.image = nil
    }

    func getFirstFrameOfVideo(url:String) -> UIImage?{

           let asset = AVURLAsset(url: URL(string: url)!, options: nil)
              let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
           do{
               let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)

                  // !! check the error before proceeding
               return UIImage(cgImage: cgImage)
           }catch let err{
               print(err)
           }
           return nil

       }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class CollectionTableViewCell:UITableViewCell {
    @objc dynamic var categoryIdPicked = 0
    @objc dynamic var categoryTitle = ""
         let collectionView:UICollectionView = {
          let layout = UICollectionViewFlowLayout()
          layout.scrollDirection = .horizontal

          let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
         cv.isPagingEnabled = true
         cv.isScrollEnabled = true
          cv.register(CategoryCell.self, forCellWithReuseIdentifier: "cell")
          return cv
      }()
//      var categories = [("Sports",1),("Movies",2),("Television",3),("Internet",13),("Music",5),("Animals",7),("Video Games",6),("Other",4)]
    override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
       }

       override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style,reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        addCollectionView()

    }

    private func addCollectionView(){

        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = false
        collectionView.addCodeConstraints(parentView: self, constraints: [
            collectionView.topAnchor.constraint(equalTo: safe().topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: safe().leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: safe().trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: safe().bottomAnchor)

        ])

        let constraint = collectionView.heightAnchor.constraint(equalToConstant: 200)
            constraint.priority = .defaultHigh
            constraint.isActive = true



    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CategoryTableViewCell: UITableViewCell {

    let categoryTitleLabel = UILabel()


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .oxfordBlue
        categoryTitleLabel.addCodeConstraints(parentView: self, constraints: [
            categoryTitleLabel.leadingAnchor.constraint(equalTo: safe().leadingAnchor, constant: 5),
            categoryTitleLabel.topAnchor.constraint(equalTo: safe().topAnchor, constant: 5)
        ])
        categoryTitleLabel.textColor = .white
        categoryTitleLabel.font = categoryTitleLabel.font.withSize(25)

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

