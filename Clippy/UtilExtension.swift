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
