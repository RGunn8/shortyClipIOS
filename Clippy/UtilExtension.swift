//
//  UtilExtension.swift
//  Clippy
//
//  Created by Ryan Gunn on 6/16/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    func addCodeConstraints(parentView:UIView,constraints:[NSLayoutConstraint]){
         parentView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }
    func safe() -> UILayoutGuide{
        return self.safeAreaLayoutGuide
    }

}

extension UIButton{
    func addOnPressed(target:UIView,selector:Selector){
        self.addTarget(target, action: selector, for: .touchUpInside)
    }
}

extension UIColor{
    static var  electricPurple:  UIColor{
        return getRGBColor(red: 183.0, green: 33.0, blue: 255.0)
    }

    static var vividSkyBlue : UIColor{
        return getRGBColor(red: 33.0, green: 212.0, blue: 253.0)
    }

    static var oxfordBlue : UIColor{
        return getRGBColor(red: 0.0, green: 13.0, blue: 56.0)
    }

    static func getRGBColor(red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat = 1.0) -> UIColor{
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}

struct Constants {
          static let FetchThreshold = 5 // a constant to determine when to fetch the results; anytime   difference between current displayed cell and your total results fall below this number you want to fetch the results and reload the table
          static let FetchLimit = 40 // results to fetch in single call
      }
