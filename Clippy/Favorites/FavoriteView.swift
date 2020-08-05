//
//  FavoriteVeiw.swift
//  Clippy
//
//  Created by Ryan Gunn on 8/3/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import UIKit

class FavoriteView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var clipsButton: UIButton!
    @IBOutlet weak var tagsButton: UIButton!
    
    @IBOutlet weak var favoriteItemsTableView: UITableView!
    
    override init(frame: CGRect) {
          super.init(frame: frame)
          commonInit(nibName: "FavoriteView",contentView: contentView)
      }

      required init?(coder: NSCoder) {
          super.init(coder: coder)
          commonInit(nibName: "FavoriteView",contentView: contentView)
      }
}
