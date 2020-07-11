//
//  DetailClipViewController.swift
//  Clippy
//
//  Created by Ryan Gunn on 6/15/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit
import AVFoundation
import LinkPresentation
import TTGTagCollectionView
import Photos

class DetailClipViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,TTGTextTagCollectionViewDelegate {
     var clip:ClipWithID? = nil
    var player = AVQueuePlayer.init()
    var playerLayer = AVPlayerLayer()
    var detailView = DetailClipView()
    var playerLooper: NSObject?
    var isStopped = false


    override func viewDidLoad() {
        super.viewDidLoad()
        try! AVAudioSession.sharedInstance().setCategory(.playback, options: [])
       detailView = DetailClipView(frame: self.view.frame)
        self.view.addSubview(detailView)
        setUpVidoePlayer()
        detailView.bindClip(clip: clip!)
        //detailView.clipTitleLabel.text = clip?.title
        detailView.shareButton.addTarget(self, action: #selector(shareVidoe(_:)), for: .touchUpInside)
        detailView.playButton.addTarget(self, action: #selector(playVideo(_:)), for: .touchUpInside)
        detailView.rewindButton.addTarget(self, action: #selector(rewindVideo(_:)), for: .touchUpInside)
        detailView.fullScreenButton.addTarget(self, action: #selector(fullScreenTapped(_:)), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapVideo(_:)))
        detailView.isUserInteractionEnabled = true
        detailView.playerContainerView.isUserInteractionEnabled = true
        detailView.playerContainerView.addGestureRecognizer(tap)
        detailView.tagCollectionView.delegate = self
//        detailView.tagCollectionView.delegate = self
//        detailView.tagCollectionView.dataSource = self
        //detailView.tagCollectionView.reloadData()
        //detailView.downloadButton.addTarget(self, action: #selector(downloadButtonTapped(_:)), for: .touchUpInside)
    }

    func setUpVidoePlayer(){
        playerLayer.player = player
        detailView.playerContainerView.layoutIfNeeded()
        playerLayer.videoGravity = .resizeAspect
        playerLayer.frame = detailView.playerContainerView.bounds
        detailView.playerContainerView.layer.insertSublayer(playerLayer, at: 0)
        playVideo()
    }


    func getMetadataForSharingManually() -> LPLinkMetadata {
        let linkMetaData = LPLinkMetadata()
//        let path = Bundle.main.path(forResource: fileName, ofType: fileType)
//        linkMetaData.iconProvider = NSItemProvider(contentsOf: URL(fileURLWithPath: path ?? ""))
        linkMetaData.originalURL = URL(string: clip!.clipURL)!
        linkMetaData.remoteVideoURL = URL(string: clip!.clipURL)!
        linkMetaData.title = clip!.title

        return linkMetaData
    }

    @objc func tapVideo(_ sender:UITapGestureRecognizer){
        if !isStopped{
            player.pause()
             detailView.playerOverlay.isHidden = false
            isStopped = true
        }
    }

    @objc func playVideo(_ sender:UITapGestureRecognizer){
        detailView.playerOverlay.isHidden = true
        player.play()
        isStopped = false
       }

    @objc func rewindVideo(_ sender:UITapGestureRecognizer){
        player.seek(to: CMTime.zero)
        player.play()
        detailView.playerOverlay.isHidden = true
        isStopped = false

       }

    @objc func fullScreenTapped(_ sender:UITapGestureRecognizer){
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
       }

    @objc func downloadButtonTapped(_ sender:UIButton){
        let status = PHPhotoLibrary.authorizationStatus()
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: self.clip!.clipURL),
                let urlData = NSData(contentsOf: url)
            {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                let filePath="\(documentsPath)/\(self.clip!.title).mp4"
                DispatchQueue.main.async {
                    urlData.write(toFile: filePath, atomically: true)
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                    }) { completed, error in
                        if completed {
                            print("Video is saved!")
                        }
                    }
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        isStopped = false
    }

    @objc func shareVidoe(_ sender:UIButton){
        let metadataItemSource = LinkPresentationItemSource(metaData: getMetadataForSharingManually())
        let ac = UIActivityViewController(activityItems: [metadataItemSource], applicationActivities: nil)
        ac.excludedActivityTypes = [.postToFlickr, .postToVimeo,.postToTencentWeibo,.postToWeibo,.addToReadingList,.assignToContact,.openInIBooks]
        self.present(ac, animated: true, completion: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player.seek(to: CMTime.zero)
        player.pause()
        isStopped = true
        //player = nil
    }


    func playVideo(){
        guard let clip  = clip else {
            return
        }
        player.removeAllItems()

        if let videoURL = URL(string: clip.clipURL) {
            let playerItem = AVPlayerItem.init(url: videoURL)
            self.player.insert(playerItem, after: nil)
            playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
            self.player.play()
            loopVideo(player)
        }
    }

    func loopVideo(_ videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            if(!self.isStopped){
                videoPlayer.seek(to: CMTime.zero)
                videoPlayer.play()

            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let tags = clip?.tags {
            return tags.count
        }else{
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TagCollectionViewCell
        if let tags = clip?.tags{
            let tag = tags[indexPath.row]
            cell.titleLabel.text = "#\(tag)"
        }

             return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: collectionView.frame.width/3.5, height: collectionView.frame.width/2)
     }

    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, canTapTag tagText: String!, at index: UInt, currentSelected: Bool, tagConfig config: TTGTextTagConfig!) -> Bool {

        if let tags = clip?.tags{
            let vc = CategoryViewController()
                   vc.getCategory = false
            vc.tag = tags[Int(index)]
                   self.navigationController?.pushViewController(vc, animated: true)
            textTagCollectionView.setTagAt(index, selected: false)
            textTagCollectionView.setNeedsLayout()
            return false

        }

        //textTagCollectionView.setTagAt(index, selected: false)
        return true
    }

    

}
