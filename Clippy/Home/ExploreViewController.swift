//
//  HomeViewController.swift
//  Clippy
//
//  Created by Ryan Gunn on 6/14/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import UIKit
import Combine
import AVFoundation

class ExploreViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    var exploreView:ExploreView!
    var clips:[ClipWithID] = []
//    var icons:[UIImage?] =  [UIImage(named: "soccer"),UIImage(named:"film"),UIImage(named:"tv"),UIImage(named:"internet"),UIImage(named:"note"),UIImage(named:"cat"),UIImage(named:"joystick"),UIImage(named:"question-mark")]
    var vcTitle:String!
    var vcSubTitle:String? = nil
    var nextURL = ""
    var pageNumber = 1
    var tag = ""
    var categoryID = 0
    var canFetchMoreResults = true
    var exploreType:ExploreType!

    override func viewDidLoad() {
        super.viewDidLoad()
        exploreView = ExploreView(frame: view.frame)
        view.addSubview(exploreView)
        self.view.backgroundColor = .clear
        self.navigationController?.navigationBar.titleTextAttributes =  [.foregroundColor: UIColor.white]
        exploreView.categoriesLabel.text = vcTitle
        exploreView.subTitleLabel.text = vcSubTitle
//        self.navigationController?.isHeroEnabled = true
//        self.navigationController?.heroNavigationAnimationType = .pageIn(direction: .right)
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe))
        swipe.direction = .right
        exploreView.categoriesBackground.addGestureRecognizer(swipe)
        exploreView.clipsTableView.dataSource = self
        exploreView.clipsTableView.delegate = self
        getClips()

    }



    private func getTagClips(){
//        ClipService.shared.getFilterClips(searchText:tag,pageNumber: pageNumber) { (response) in
//                            DispatchQueue.main.async {
//                                switch response{
//                                case .Success(let newClips):
//                                 self.updateTableView(newClips)
//                                case .Error(let error):
//                                    print(error)
//
//                             }
//                     }
//             }

        ClipRealmService.sharedInstance.getFilterClips(searchText: tag) { (response) in
                    switch response{
                            case .Success(let newClips):
                                self.updateTableView(newClips.shuffled())
                            case .Error(let error):
                                print(error)

                                }
        }
    }

    private func  getCategoryClips(){
        ClipService.shared.getCategoryClips(categoryID:categoryID,pageNumber: pageNumber) { (response) in
                                DispatchQueue.main.async {
                                    switch response{
                                    case .Success(let newClips):
                                    self.updateTableView(newClips)
                                    case .Error(let error):
                                        print(error)

                                 }
                         }
                 }
    }

    fileprivate func updateTableView(_ newClips: Codable) {
        let addClips = newClips as! ClipListResponse
         var intialCount = self.clips.count - 1
        self.clips.append(contentsOf: addClips.results)
        if intialCount == -1 {
            self.exploreView.clipsTableView.reloadData()

        }else{
            var paths = [IndexPath]()
            for _ in addClips.results{
                paths.append(IndexPath(row: intialCount, section: 0))
                intialCount += 1
            }


            self.exploreView.clipsTableView.beginUpdates()
            self.exploreView.clipsTableView.insertRows(at: paths, with: .automatic)
            self.exploreView.clipsTableView.endUpdates()
        }
        self.pageNumber += 1


    }


    @objc func onSwipe(){
           self.navigationController?.popViewController(animated: true)
       }

    func getClips(){
        switch exploreType {
        case .tag(let tagString):
            self.tag = tagString
            self.getTagClips()
            break
        case .category(let detailCategoryID):
            self.categoryID = detailCategoryID
            getCategoryClips()
            break
        default:
             getAllClips()
        }
    }

    func getAllClips(){
        ClipService.shared.getAllClips(pageNumber: pageNumber) { (response) in
            DispatchQueue.main.async {
                                               switch response{
                                               case .Success(let newClips):
                                               self.updateTableView(newClips)
                                               case .Error(let error):
                                                   print(error)

                                            }
                                    }
        }

    }


    private func fetchDataFromIndex() {
       getClips()
     }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let pan = scrollView.panGestureRecognizer
//        let velocity = pan.velocity(in: scrollView).y
//        if velocity < -5 {
//            self.navigationController?.setNavigationBarHidden(true, animated: true)
//            self.navigationController?.setToolbarHidden(true, animated: true)
//        } else if velocity > 5 {
//            self.navigationController?.setNavigationBarHidden(false, animated: true)
//            self.navigationController?.setToolbarHidden(false, animated: true)
//        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        clipsTableView.layoutIfNeeded()
//        setTableViewBackgroundGradient(UIColor.electricPurple, UIColor.vividSkyBlue)
    }



    @objc func displayAddViewController(_ sender: UIBarButtonItem){
        let addVC = AddClipViewController()
        self.modalPresentationStyle = .overCurrentContext
        self.present(addVC, animated: true, completion: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clips.count

      }

      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let clip = self.clips[indexPath.row]
                   let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
                
                   cell.bindCell(clip: clip)
                   return cell

      }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailClipViewController()
        detailVC.clip = clips[indexPath.row]
        self.present(detailVC, animated: true, completion: nil)
        //self.navigationController?.pushViewController(detailVC, animated: true)
         tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         if (clips.count - indexPath.row) == Constants.FetchThreshold && canFetchMoreResults {
             fetchDataFromIndex()
         }
     }
}

enum ExploreType {
    case rand,
    category(categoryID:Int),
    tag(tagString:String)
}

