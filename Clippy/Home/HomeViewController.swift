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

class HomeViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    var clips:[ClipWithID] = []
    var categories = [("Sports",1),("Movies",2),("Television",3),("Internet",13),("Music",5),("Animals",7),("Video Games",6),("Other",4)]
    var icons:[UIImage?] =  [UIImage(named: "soccer"),UIImage(named:"film"),UIImage(named:"tv"),UIImage(named:"internet"),UIImage(named:"note"),UIImage(named:"cat"),UIImage(named:"joystick"),UIImage(named:"question-mark")]
    let homeTableView = UITableView()
    var nextURL = ""
    var pageNumber = 1
    var canFetchMoreResults = true
 

    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(displayAddViewController(_:)))
        self.navigationItem.title = "ShortyClips"
        self.view.backgroundColor = .clear
        self.navigationItem.rightBarButtonItem  = addButton
        self.navigationController?.navigationBar.barTintColor = UIColor.electricPurple
        self.navigationController?.navigationBar.titleTextAttributes =  [.foregroundColor: UIColor.white]
        homeTableView.addCodeConstraints(parentView: self.view, constraints: [
            homeTableView.topAnchor.constraint(equalTo: view.safe().topAnchor),
            homeTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            homeTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            homeTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
        homeTableView.rowHeight = UITableView.automaticDimension
        homeTableView.register(CollectionTableViewCell.self, forCellReuseIdentifier: "collectionCell")
        homeTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "cell")
        homeTableView.estimatedRowHeight = 200
        homeTableView.dataSource = self
        homeTableView.delegate = self



        ClipService.shared.getAllClips { (response) in
                       DispatchQueue.main.async {
                           switch response{
                           case .Success(let newClips):
                            let addClips = newClips as! ClipListResponse
                            self.clips.append(contentsOf: addClips.results)
                            self.homeTableView.reloadData()
                            self.pageNumber += 1
                           case .Error(let error):
                               print(error)

                        }
                }
        }

    }

    private func fetchDataFromIndex() {

            ClipService.shared.getAllClips(pageNumber: pageNumber) { (response) in
                               DispatchQueue.main.async {
                                   switch response{
                                   case .Success(let newClips):
                                    let addClips = newClips as! ClipListResponse
                                    self.clips.append(contentsOf: addClips.results)
                                    self.homeTableView.reloadData()
                                    self.pageNumber += 1
                                    self.canFetchMoreResults = addClips.next != nil
                                   case .Error(let error):
                                       print(error)

                                }
                        }
                }
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
        homeTableView.layoutIfNeeded()
        setTableViewBackgroundGradient(UIColor.electricPurple, UIColor.vividSkyBlue)
    }

    func setTableViewBackgroundGradient(_ topColor:UIColor, _ bottomColor:UIColor) {

        let gradientBackgroundColors = [topColor.cgColor, bottomColor.cgColor]
       //let gradientLocations = [0,1]

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientBackgroundColors
        gradientLayer.locations = [0,1]


        gradientLayer.frame = self.view.frame
        let backgroundView = UIView(frame: self.view.frame)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        homeTableView.backgroundView = backgroundView

    }

    @objc func displayAddViewController(_ sender: UIBarButtonItem){
        let addVC = AddClipViewController()
        self.present(addVC, animated: true, completion: nil)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
        return clips.count
        }
      }

      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
                   let cell = tableView.dequeueReusableCell(withIdentifier: "collectionCell", for: indexPath) as! CollectionTableViewCell

            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self

                   return cell
        }else{
            let clip = self.clips[indexPath.row]
                   let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
                
                   cell.bindCell(clip: clip)
                   return cell
        }

      }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailClipViewController()
        detailVC.clip = clips[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
         tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         if (clips.count - indexPath.row) == Constants.FetchThreshold && canFetchMoreResults {
             fetchDataFromIndex()
         }
     }


}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.width/2)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
        let vc = CategoryViewController()
        vc.title =  self.categories[indexPath.item].0
        vc.categoryID =  self.categories[indexPath.item].1
        self.navigationController?.pushViewController(vc, animated: true)
       
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryCell
            cell.categoryTitle.text = self.categories[indexPath.item].0
        cell.categoryIcon.image = self.icons[indexPath.item]
        return cell
    }
}

