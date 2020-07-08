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

class HomeViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    var clips:[ClipWithID] = []
    var categories = ["Sports","Televiosn","MOvie","Polotics","Internt"]
    let homeTableView = UITableView()
    fileprivate let collectionView:UICollectionView = {
         let layout = UICollectionViewFlowLayout()
         layout.scrollDirection = .horizontal

         let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.isScrollEnabled = true
         cv.register(CategoryCell.self, forCellWithReuseIdentifier: "cell")
         return cv
     }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(displayAddViewController(_:)))
        self.navigationItem.rightBarButtonItem  = addButton
        addCollectionView()
        homeTableView.addCodeConstraints(parentView: self.view, constraints: [
            homeTableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            homeTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            homeTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            homeTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
        homeTableView.rowHeight = UITableView.automaticDimension
        homeTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "cell")
        homeTableView.estimatedRowHeight = 20
        homeTableView.dataSource = self
        homeTableView.delegate = self

        ClipService.shared.getAllClips { (response) in
                       DispatchQueue.main.async {
                           switch response{
                           case .Success(let newClips):
                            let addClips = newClips as! TrendingClipResponse
                            self.clips.append(contentsOf: addClips.clips)
                            self.homeTableView.reloadData()
                           case .Error(let error):
                               print(error)

                        }
                }
        }

    }

    func addCollectionView(){

        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.addCodeConstraints(parentView: self.view, constraints: [
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.heightAnchor.constraint(equalToConstant: 205)
        ])


    }

    @objc func displayAddViewController(_ sender: UIBarButtonItem){
        let addVC = AddClipViewController()
        self.present(addVC, animated: true, completion: nil)
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
        self.navigationController?.pushViewController(detailVC, animated: true)
    }


}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.width/2)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryCell
        cell.categoryTitle.text = self.categories[indexPath.item]
        return cell
    }
}
