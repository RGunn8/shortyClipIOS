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

class DetailClipViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,TTGTextTagCollectionViewDelegate {

     var clip:ClipWithID? = nil
    var relatedClip:[ClipWithID] = []
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
        ClipService.shared.getClipDetail(clipdID: clip!.id) { (response) in
            DispatchQueue.main.async {
                switch response{
                    case .Success(let newClips):
                        let clipDetail = newClips as! ClipDetailResponse
                        self.detailView.bindClip(clip: clipDetail.clip)
                        if let relatedClips = clipDetail.relatedClip{
                        if relatedClips.isEmpty{
                            self.detailView.releatedClipTableView.isHidden = true
                        }else{
                        self.relatedClip.append(contentsOf:relatedClips)
                        self.detailView.releatedClipTableView.reloadData()
                        }

                    }

                    case .Error(let error):
                        print(error)

                    }
                }
        }
        setUpVidoePlayer()
        detailView.releatedClipTableView.delegate = self
        detailView.releatedClipTableView.dataSource = self
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

    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, canTapTag tagText: String!, at index: UInt, currentSelected: Bool, tagConfig config: TTGTextTagConfig!) -> Bool {

        if let tags = clip?.tags{
//
//            let vc = CategoryViewController()
//                   vc.getCategory = false
//            vc.tag = tags[Int(index)]
//                   self.navigationController?.pushViewController(vc, animated: true)
//            textTagCollectionView.setTagAt(index, selected: false)
//            textTagCollectionView.setNeedsLayout()

            let vc = ExploreViewController()
            let tag = tags[Int(index)]
                   vc.vcTitle = tag
                   vc.vcSubTitle = "Tag"
            vc.exploreType = .tag(tagString: tag)
            self.present(vc, animated: true, completion: nil)

                textTagCollectionView.setTagAt(index, selected: false)
                textTagCollectionView.setNeedsLayout()
            return false

        }

        //textTagCollectionView.setTagAt(index, selected: false)
        return true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return relatedClip.count
      }

      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let clip = self.relatedClip[indexPath.row]
                         let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RelatedClipTableViewCell
                         cell.bindCell(clip: clip)
            return cell
      }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Related Clips"
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let detailVC = DetailClipViewController()
         detailVC.clip = relatedClip[indexPath.row]
        // self.present(detailVC, animated: true, completion: nil)
         self.navigationController?.pushViewController(detailVC, animated: true)
          tableView.deselectRow(at: indexPath, animated: true)
     }

    

}
