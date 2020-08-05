//
//  RelatedClipTableViewCell.swift
//  Clippy
//
//  Created by Ryan Gunn on 7/23/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import UIKit
import AVFoundation

class RelatedClipTableViewCell: UITableViewCell {

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
                clipPreviewImageView.leadingAnchor.constraint(equalTo: safe().leadingAnchor,constant: 10),
                clipPreviewImageView.topAnchor.constraint(equalTo: safe().topAnchor, constant: 5),
                clipPreviewImageView.widthAnchor.constraint(equalToConstant: 100),
                clipPreviewImageView.heightAnchor.constraint(equalToConstant: 100),
                 clipPreviewImageView.bottomAnchor.constraint(equalTo: safe().bottomAnchor,constant: -10)
    //            clipPreviewImageView.bottomAnchor.con
            ])
            clipPreviewImageView.backgroundColor = .blue
            self.backgroundColor = UIColor.clear
//            let constraint = clipPreviewImageView.heightAnchor.constraint(equalToConstant: 200)
//            constraint.priority = .defaultHigh
//            constraint.isActive = true

            clipDurationLabel.addCodeConstraints(parentView: clipPreviewImageView, constraints: [
                clipDurationLabel.bottomAnchor.constraint(equalTo: clipPreviewImageView.bottomAnchor,constant: -10),
                clipDurationLabel.trailingAnchor.constraint(equalTo: clipPreviewImageView.trailingAnchor,constant: -10)

            ])

            clipDurationLabel.backgroundColor = .black
            clipDurationLabel.textColor = .white

            clipTitleLabel.addCodeConstraints(parentView: self, constraints: [
                clipTitleLabel.centerYAnchor.constraint(equalTo: safe().centerYAnchor),
                clipTitleLabel.leadingAnchor.constraint(equalTo: clipPreviewImageView.trailingAnchor,constant: 10),
                clipTitleLabel.trailingAnchor.constraint(equalTo: safe().trailingAnchor, constant: -10),
                //clipTitleLabel.bottomAnchor.constraint(equalTo: safe().bottomAnchor,constant: -10)
            ])

           // clipTitleLabel.textAlignment = .center
            clipTitleLabel.numberOfLines = 0
            clipTitleLabel.lineBreakMode = .byWordWrapping


            clipUserNameLabel.addCodeConstraints(parentView: self, constraints: [
                clipUserNameLabel.topAnchor.constraint(equalTo: clipTitleLabel.bottomAnchor, constant: 10),
                clipUserNameLabel.leadingAnchor.constraint(equalTo: clipTitleLabel.leadingAnchor),
                clipUserNameLabel.trailingAnchor.constraint(equalTo: clipTitleLabel.trailingAnchor),

            ])
           // clipUserNameLabel.textAlignment = .center

        }

        func bindCell(clip:ClipWithID){
            self.clipUserNameLabel.text = clip.user
            self.clipTitleLabel.text = clip.title
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
