//
//  UserInfoView.swift
//  Clippy
//
//  Created by Ryan Gunn on 8/3/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import Foundation
import UIKit

class UserInfoView:UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var myFavoriteButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var clipsTableVeiw: UITableView!

    override init(frame: CGRect) {
        super.init(frame: frame)
         commonInit()
//        commonInit(nibName: "UserInfoView",contentView: contentView)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
//        commonInit(nibName: "UserInfoView",contentView: contentView)
    }

    override func awakeFromNib() {
//                commonInit(nibName: "UserInfoView",contentView: contentView)
    }

    private func commonInit(){
        Bundle.main.loadNibNamed("UserInfoView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
    }
}
