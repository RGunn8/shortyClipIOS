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
import TTGTagCollectionView


class AddClipViewController: UIViewController, UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIVideoEditorControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,TTGTextTagCollectionViewDelegate  {
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
    var categoryIndexSelected = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        try! AVAudioSession.sharedInstance().setCategory(.playback, options: [])
        homeView = AddClipView(frame: self.view.frame)
        self.view.addSubview(homeView)
       // homeView.tagCollectionView.delegate = self
        homeView.addTagTextView.delegate = self
        homeView.tagCollectionView.delegate = self
        homeView.selectVideoButton.addTarget(self, action: #selector(self.openVideoGallery(_:)), for: .touchUpInside)
        homeView.saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        homeView.editButton.addTarget(self,action: #selector(editButtonTapped(_:)), for: .touchUpInside)
        setUpVidoePlayer()
        setTableViewBackgroundGradient()
        createPickerView()
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


    func setTableViewBackgroundGradient() {

        let gradientBackgroundColors = [UIColor.white.cgColor, UIColor.red.cgColor]
       //let gradientLocations = [0,1]

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = [0,1]


        gradientLayer.frame = self.view.frame
        let backgroundView = UIView(frame: self.view.frame)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        //homeTableView.backgroundView = backgroundView

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
//            tags.append(homeView.addTagTextView.text)
            homeView.tagCollectionView.addTag("\(homeView.addTagTextView.text ?? "") X")
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

//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return tags.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TagCollectionViewCell
//        cell.titleLabel.text = tags[indexPath.row]
//        return cell
//
//    }

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

    func createPickerView() {
           let pickerView = UIPickerView()
           pickerView.delegate = self
        pickerView.dataSource = self
        homeView.categoryTextView.inputView = pickerView
        dismissPickerView()

    }
    func dismissPickerView() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
        homeView.categoryTextView.inputAccessoryView = toolBar
    }
    @objc func action() {
          view.endEditing(true)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1 // number of session
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.categories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.categories[row].0
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryIndexSelected = row
    homeView.categoryTextView.text = Constants.categories[row].0
    }

    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, canTapTag tagText: String!, at index: UInt, currentSelected: Bool, tagConfig config: TTGTextTagConfig!) -> Bool {
        textTagCollectionView.removeTag(at: index)
        textTagCollectionView.reload()

            return false

    }
}



