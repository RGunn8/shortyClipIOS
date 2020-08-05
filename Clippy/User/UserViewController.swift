//
//  UserViewController.swift
//  Clippy
//
//  Created by Ryan Gunn on 7/10/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    var userInfoView:UserInfoView!

    override func viewDidLoad() {
        super.viewDidLoad()
        userInfoView = UserInfoView(frame: view.frame)
        self.view.addSubview(userInfoView)
        
    }

}
