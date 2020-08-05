//
//  FavoriteViewController.swift
//  Clippy
//
//  Created by Ryan Gunn on 8/3/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {
    var favoriteView:FavoriteView!
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteView = FavoriteView(frame:view.frame)
        view.addSubview(favoriteView)

    }


}
