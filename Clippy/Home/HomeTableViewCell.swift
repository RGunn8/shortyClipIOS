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

    let clipPreviewImageView = UIView()
    let clipTitleLabel = UILabel()
    let clipUserNameLabel = UILabel()
    let clipLikesLabel = UILabel()
    var playerLayer = AVPlayerLayer()

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

        ])
        clipPreviewImageView.backgroundColor = .blue

        let constraint = clipPreviewImageView.heightAnchor.constraint(equalToConstant: 200)
        constraint.priority = .defaultHigh
        constraint.isActive = true

        clipTitleLabel.addCodeConstraints(parentView: self, constraints: [
            clipTitleLabel.centerXAnchor.constraint(equalTo: clipPreviewImageView.centerXAnchor),
            clipTitleLabel.topAnchor.constraint(equalTo: clipPreviewImageView.bottomAnchor, constant: 10),
            clipTitleLabel.leadingAnchor.constraint(equalTo: safe().leadingAnchor,constant: 10),
            clipTitleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            clipTitleLabel.bottomAnchor.constraint(equalTo: safe().bottomAnchor,constant: -10)
        ])

        clipUserNameLabel.addCodeConstraints(parentView: self, constraints: [
            clipUserNameLabel.topAnchor.constraint(equalTo: clipTitleLabel.bottomAnchor, constant: 10),
            clipUserNameLabel.leadingAnchor.constraint(equalTo: clipTitleLabel.leadingAnchor, constant: 0),
            clipUserNameLabel.bottomAnchor.constraint(equalTo: safe().bottomAnchor,constant: -10)

        ])

        clipLikesLabel.addCodeConstraints(parentView: self, constraints: [
            clipLikesLabel.topAnchor.constraint(equalTo: clipUserNameLabel.topAnchor),
            clipLikesLabel.leadingAnchor.constraint(equalTo: clipUserNameLabel.trailingAnchor,constant: 10),
            clipLikesLabel.bottomAnchor.constraint(equalTo: clipUserNameLabel.bottomAnchor)
        ])
    }

    func bindCell(clip:ClipWithID){
        self.clipUserNameLabel.text = clip.user
        self.clipTitleLabel.text = clip.title
        self.clipLikesLabel.text = "Favorited: \(clip.likes)"
        playerLayer.videoGravity = .resizeAspectFill
        clipPreviewImageView.layoutIfNeeded()
        playerLayer.frame = clipPreviewImageView.bounds
        clipPreviewImageView.layer.addSublayer(playerLayer)
        playerLayer.player = AVPlayer(url: URL(string: clip.clipURL)!)
//        DispatchQueue.global(qos: .background).async {
//            let image =  self.getFirstFrameOfVideo(url: clip.clipURL)
//            DispatchQueue.main.async {
//                self.clipPreviewImageView.image = image
//            }
//        }
    }

    override func prepareForReuse() {
        //self.clipPreviewImageView.image = nil
    }

    func getFirstFrameOfVideo(url:String) -> UIImage?{

           let asset = AVURLAsset(url: URL(string: url)!, options: nil)
              let imgGenerator = AVAssetImageGenerator(asset: asset)
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
