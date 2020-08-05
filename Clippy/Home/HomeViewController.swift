//
//  HomeViewController.swift
//  Clippy
//
//  Created by Ryan Gunn on 7/14/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import UIKit
import SwiftCSV
import RealmSwift

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {


    var homeView:HomeView!
    let app = RealmApp(id: "shortyclip-sxkkl")

    override func viewDidLoad() {
        super.viewDidLoad()
        homeView = HomeView(frame: view.frame)
        view.addSubview(homeView)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        homeView.categoriesTableView.delegate = self
        homeView.categoriesTableView.dataSource = self
        print(homeView.topBarView.newClipBackground.frame)
        homeView.topBarView.newClipBackground.layoutIfNeeded()
         //print(homeView.topBarView.newClipBackground.frame)
           // homeView.topBarView.newClipBackground.addTapGesture(target: self, selector: #selector(onSearchTapped(_:)))
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe))
        swipe.direction = .left
        homeView.exploreBackground.addGestureRecognizer(swipe)

//        ClipService.shared.getAllClips{ (response) in
//                             DispatchQueue.main.async {
//                                 switch response{
//                                 case .Success(let newClips):
//                                  let addClips = newClips as! ClipListResponse
//                                  self.homeView.bindClip(clip: addClips.results[0])
//                                 case .Error(let error):
//                                     print(error)
//
//                              }
//                      }
//              }
        //getRealm()
//

    }

    func getRealm(){
        let user = app.currentUser()
        let partitionValue = "PUBLIC"
        Realm.asyncOpen(configuration: user!.configuration(partitionValue: partitionValue),
            callback: { (maybeRealm, error) in
                guard error == nil else {
                    fatalError("Failed to open realm: \(error!)")
                }
                guard let realm = maybeRealm else {
                    fatalError("realm is nil!")
                }
                //self.addClips(realm: realm)
               // self.printClips(realm: realm)
                // realm opened

            })
    }

//    func printClips(realm:Realm){
//        let clips = realm.objects(Clip.self);
//        print(clips.count)
//        for clip in clips{
//            print(clip)
//        }
//    }
//
//    func addClips(realm:Realm){
//        var clipList:[Clip] = []
//        do {
//            let user = User()
//            user.username = "ShortyClip"
//            user.email = "shortyclips@test.com"
//            try! realm.write {
//                                 //Delete all objects from the realm.
//                                realm.deleteAll();
//                            }
//
//            let csv = try CSV(name: "Clips", extension: "csv", bundle: .main, delimiter: ",", encoding: .utf8, loadColumns: true)
//
//            for row in csv!.namedRows{
//                let newClip = Clip()
//                newClip.title = row["Title"]!
//                newClip.clipCategory = Int(row["Category"]!)!
//                newClip.clipURL = row["ClipURl"]!
//                newClip.duration = Int(row["Duration"]!)!
//                let tags = row["Tags"]!.components(separatedBy: ",")
//                let tagList = List<String>()
//                tagList.append(objectsIn: tags)
//                newClip.tags = tagList
//                clipList.append(newClip)
//
//
//            }
//
//        } catch {
//            print("error")
//        }
//
//        do {
//
//                try realm.write {
//                    realm.add(clipList, update: .modified)
//                    }
//                        }catch{
//
//                        }
//
//    }



    @objc func onSearchTapped(_ guesture:UITapGestureRecognizer){
        print("on tapped")
        tabBarController?.selectedIndex = 1
    }



    @objc func onSwipe(){
        let vc = ExploreViewController()
        vc.exploreType = .rand
        vc.vcTitle = "Categories"
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.categories.count
      }

      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CategoryTableViewCell
        cell.categoryTitleLabel.text = Constants.categories[indexPath.row].0
        return cell
      }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ExploreViewController()
        vc.vcTitle = Constants.categories[indexPath.row].0
        vc.vcSubTitle = "Category"
        vc.exploreType = .category(categoryID: Constants.categories[indexPath.row].1)
        self.navigationController?.pushViewController(vc, animated: true)
         tableView.deselectRow(at: indexPath, animated: true)
    }


}
