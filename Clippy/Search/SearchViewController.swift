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
    var searchView:SearchView!
    var searchController: UISearchController!
     private var cancellableBag = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        searchView = SearchView(frame:view.frame)
        self.view.addSubview(searchView)
        setUpSearchController()

        searchView.searchTableView.dataSource = self
        searchView.searchTableView.delegate = self
        searchView.popularSearchStackView.isUserInteractionEnabled = true

        ClipService.shared.getPopularSearch { (response) in
            DispatchQueue.main.async {
                        switch response{
                            case .Success(let searchItems):
//                                self.searchView.searchTableView.isHidden = true
//                                self.searchView.spinner.isHidden = true
                                let searchItemsResponse = searchItems as! SearchItemResponse
                                for searchItem in searchItemsResponse.searchItems{
                                    let searchItemLabel = UILabel()
                                    searchItemLabel.isUserInteractionEnabled = true
                                    searchItemLabel.text = searchItem.searchItem
                                    self.searchView.popularSearchStackView.addArrangedSubview(searchItemLabel)
                                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.searchItemTapped(_:)))
                                    searchItemLabel.addGestureRecognizer(tap)
                                    self.showPopularSearchResults()
                            }
                                           case .Error(let error):
                                               print(error)

                                    }
                            }
                }

    }

    @objc func searchItemTapped(_ guesture:UITapGestureRecognizer){
        let label = guesture.view as! UILabel
        let vc = CategoryViewController()
        vc.getCategory = false
        vc.tag = label.text!
        self.navigationController?.pushViewController(vc, animated: true)
    }

    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }



    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }

    func setUpSearchController(){
        searchController = UISearchController(searchResultsController: nil)
           searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search By Title,Tag,or User"
       // searchView.searchTableView.tableHeaderView = searchController.searchBar
           definesPresentationContext = true
            searchBarListner()
    }

    func searchBarListner() {
        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
        publisher.map{
            ($0.object as! UISearchTextField).text
        }.debounce(for: .milliseconds(500), scheduler: RunLoop.main).sink { (searchText) in
            if let searchText = searchText{
                if self.isFiltering{
                    self.showSpinner()
                }else{
                    self.showPopularSearchResults()
                }
                ClipService.shared.addSearchItem(searchItem: searchText)
                self.updateSearchResults(searchText: searchText)
            }
        }.store(in: &cancellableBag)

    }

    func showPopularSearchResults(){
        searchView.popularSearchStackView.isHidden = false
        searchView.popularsSearchLabel.isHidden = false
        searchView.searchTableView.isHidden = true
        searchView.spinner.isHidden = true
    }

    func showSearchTableView(){
        searchView.popularSearchStackView.isHidden = true
             searchView.searchTableView.isHidden = false
        searchView.popularsSearchLabel.isHidden = true
             searchView.spinner.isHidden = true
    }

    func showSpinner(){
        searchView.popularSearchStackView.isHidden = true
             searchView.searchTableView.isHidden = true
        searchView.popularsSearchLabel.isHidden = true
             searchView.spinner.isHidden = false
        searchView.spinner.startAnimating()
    }

    func updateSearchResults(searchText:String){
        ClipService.shared.getFilterClips(searchText:searchText){ (response) in
                            DispatchQueue.main.async {
                                switch response{
                                case .Success(let newClips):
                                    self.showSearchTableView()
                                 let addClips = newClips as! ClipListResponse
                                 self.searchClips.removeAll()
                                 self.searchClips.append(contentsOf: addClips.results)
                                 self.searchView.searchTableView.reloadData()
                                case .Error(let error):
                                    print(error)

                             }
                         }
             }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            if searchClips.isEmpty || isSearchBarEmpty {
                showPopularSearchResults()
            }
             return searchClips.count
        }else {
            showPopularSearchResults()
             return 0
        }

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
