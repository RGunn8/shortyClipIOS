//
//  SearchViewController.swift
//  Clippy
//
//  Created by Ryan Gunn on 6/19/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import UIKit
import Combine

class SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var searchClips:[ClipWithID] = []
    let searchTableView = UITableView()
    var searchController: UISearchController!
     private var cancellableBag = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTableView.addCodeConstraints(parentView: self.view, constraints: [
            searchTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            searchTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            searchTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            searchTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0)
        ])
        setUpSearchController()
        searchTableView.rowHeight = UITableView.automaticDimension
        searchTableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "cell")
        searchTableView.estimatedRowHeight = 20
        searchTableView.dataSource = self
        searchTableView.delegate = self

    }

    func setUpSearchController(){
        searchController = UISearchController(searchResultsController: nil)
           searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        
           searchTableView.tableHeaderView = searchController.searchBar
           definesPresentationContext = true
            searchBarListner()
    }

    func searchBarListner() {
        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
        publisher.map{
            ($0.object as! UISearchTextField).text
        }.debounce(for: .milliseconds(500), scheduler: RunLoop.main).sink { (searchText) in
            if let searchText = searchText{
                self.updateSearchResults(searchText: searchText)
            }
        }.store(in: &cancellableBag)

    }

    func updateSearchResults(searchText:String){
        ClipService.shared.getFilterClips(searchText:searchText){ (response) in
                            DispatchQueue.main.async {
                                switch response{
                                case .Success(let newClips):
                                 let addClips = newClips as! ClipListResponse
                                 self.searchClips.removeAll()
                                 self.searchClips.append(contentsOf: addClips.results)
                                 self.searchTableView.reloadData()
                                case .Error(let error):
                                    print(error)

                             }
                         }
             }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchClips.count
      }

      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let clip = self.searchClips[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeTableViewCell
        cell.bindCell(clip: clip)
        return cell
      }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailClipViewController()
        detailVC.clip = searchClips[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }


}
