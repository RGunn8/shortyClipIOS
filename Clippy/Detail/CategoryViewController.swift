//
//  CategoryViewController.swift
//  Clippy
//
//  Created by Ryan Gunn on 7/8/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var clips:[ClipWithID] = []
    let homeTableView = UITableView()
    var categoryID = 0
    var categoryTitle = ""
    var nextURL = ""
    var pageNumber = 1
    var canFetchMoreResults = true
    var getCategory = true
    var tag = ""


        override func viewDidLoad() {
            super.viewDidLoad()
            homeTableView.addCodeConstraints(parentView: self.view, constraints: [
                homeTableView.topAnchor.constraint(equalTo: view.safe().topAnchor),
                homeTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                homeTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                homeTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
            ])
            homeTableView.rowHeight = UITableView.automaticDimension
            homeTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "cell")
            homeTableView.estimatedRowHeight = 200
            homeTableView.dataSource = self
            homeTableView.delegate = self

            if getCategory{
                self.navigationItem.title = categoryTitle
                getCategoryClips()
            }else{
                self.navigationItem.title = tag
                getTagClips()
            }



        }

    private func getTagClips(){
        ClipService.shared.getFilterClips(searchText:tag) { (response) in
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

    private func  getCategoryClips(){
        ClipService.shared.getCategoryClips(categoryID:categoryID) { (response) in
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
            self.homeTableView.reloadData()

        }else{
            var paths = [IndexPath]()
            for _ in addClips.results{
                paths.append(IndexPath(row: intialCount, section: 0))
                intialCount += 1
            }


            self.homeTableView.beginUpdates()
            homeTableView.insertRows(at: paths, with: .automatic)
            self.homeTableView.endUpdates()
        }
        self.pageNumber += 1
        self.canFetchMoreResults = addClips.next != nil

    }

    private func fetchTagDataFromIndex() {
             ClipService.shared.getFilterClips(searchText:tag,pageNumber: pageNumber) { (response) in
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


        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return clips.count

          }

          func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let clip = self.clips[indexPath.row]
                       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
                      // cell.bindCell(clip: clip)
                       return cell


          }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let detailVC = DetailClipViewController()
            //detailVC.clip = clips[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (clips.count - indexPath.row) == Constants.FetchThreshold && canFetchMoreResults {
            if getCategory {
                fetchDataFromIndex()
            }else{
                fetchTagDataFromIndex()
            }

        }
    }



}
