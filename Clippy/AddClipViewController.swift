//
//  ViewController.swift
//  Clippy
//
//  Created by Ryan Gunn on 6/6/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit
import AVFoundation
import Cloudinary


class AddClipViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIVideoEditorControllerDelegate {
    var picker = UIImagePickerController()
    var player = AVQueuePlayer.init()
    var playerLayer = AVPlayerLayer()
    var videoURL:URL? = nil
    var homeView:AddClipView!
    var tags :[String] = []
    var playerLooper: NSObject?
    var isStopped = false
    var vidoeDuration = 0
    var clipURL:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        try! AVAudioSession.sharedInstance().setCategory(.playback, options: [])
        homeView = AddClipView(frame: self.view.frame)
        self.view.addSubview(homeView)
        homeView.tagCollectionView.delegate = self
        homeView.tagCollectionView.dataSource = self
        homeView.addTagTextView.delegate = self
        homeView.selectVideoButton.addTarget(self, action: #selector(self.openVideoGallery(_:)), for: .touchUpInside)
        homeView.saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        homeView.editButton.addTarget(self,action: #selector(editButtonTapped(_:)), for: .touchUpInside)
        setUpVidoePlayer()
    }

    @objc func editButtonTapped(_ sender:UIButton){
        if let videoURL = videoURL{
            if UIVideoEditorController.canEditVideo(atPath: videoURL.absoluteString) {
                              let editController = UIVideoEditorController()
                editController.videoPath = videoURL.path
                              editController.delegate = self
                              present(editController, animated:true)
                          }
        }

    }

    @objc func saveButtonTapped(_ sender: UIButton){
        let config = CLDConfiguration(cloudName: "djv8pig93", secure: true)
        let cloudinary = CLDCloudinary(configuration: config)
        let params = CLDUploadRequestParams()
        params.setResourceType(.video)
        cloudinary.createUploader().upload(url: videoURL!, uploadPreset: "ospdlnqd",params: params).response { (response, error) in
            if let cloudError = error  {
                print(cloudError)
                return
            }
            DispatchQueue.main.async {
                self.clipURL =  response!.resultJson["secure_url"] as! String
                self.addClip()
            }

        }

    }

    func addClip(){
        let clip = ClipPost(title: homeView.addTitleTextView.text, duration: vidoeDuration, likes: 0, clipURL: clipURL!, tags: tags,category: Category(id: 1, name: "Sports"))
        ClipService.shared.addClip(clip: clip) { (response) in
            DispatchQueue.main.async {
                switch response{
                case .Success( _):
                    self.dismiss(animated: true, completion: nil)
                case .Error(let error):
                    print(error)

                }
            }
        }

    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
         if(text == "\n") {
            tags.append(homeView.addTagTextView.text)
            homeView.tagCollectionView.reloadData()
            textView.text = ""
             textView.resignFirstResponder()
             return false
        }
         return true
     }

    func setUpVidoePlayer(){
        playerLayer.player = player
        homeView.playerContainerView.layoutIfNeeded()
        playerLayer.videoGravity = .resizeAspect
        playerLayer.frame = homeView.playerContainerView.bounds
        homeView.playerContainerView.layer.addSublayer(playerLayer)
    }

    func playVideo(){
        player.removeAllItems()
        if let videoURL = videoURL {
            let playerItem = AVPlayerItem.init(url: videoURL)
            self.player.insert(playerItem, after: nil)
            playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
            self.player.play()
            loopVideo(player)
        }
    }

    func loopVideo(_ videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
//            if(!self.isStopped){
//                videoPlayer.seek(to: CMTime.zero)
//                videoPlayer.play()
//
//            }
        }
    }

   @objc func openVideoGallery(_ sender: UIButton) {
        picker = UIImagePickerController()
        picker.delegate = self
    picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
             print("videoURL:\(String(describing: videoURL))")
        let asset = AVAsset(url: videoURL!)
        let duration = asset.duration
        let durationTime = CMTimeGetSeconds(duration)
        vidoeDuration = Int(durationTime)
        self.dismiss(animated: true, completion: nil)
          playVideo()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TagCollectionViewCell
        cell.titleLabel.text = tags[indexPath.row]
        return cell

    }

    func videoEditorController(_ editor: UIVideoEditorController,
         didSaveEditedVideoToPath editedVideoPath: String) {
        // dismiss(animated:true)
        print(editedVideoPath)
      }

      func videoEditorControllerDidCancel(_ editor: UIVideoEditorController) {
         //dismiss(animated:true)
      }

      func videoEditorController(_ editor: UIVideoEditorController,
                 didFailWithError error: Error) {
         print("an error occurred: \(error.localizedDescription)")
         //dismiss(animated:true)
      }
}

