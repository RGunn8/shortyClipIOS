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

    func addTapGesture(target:AnyObject,selector:Selector){
          let tapAction = UITapGestureRecognizer(target: target, action: selector)
          self.isUserInteractionEnabled = true
          self.addGestureRecognizer(tapAction)
      }

      func commonInit(nibName:String,contentView:UIView){
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        self.addSubview(contentView)
          contentView.frame = self.bounds
          contentView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
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


    static let categories = [("Sports",1),("Movies",2),("Television",3),("Internet",13),("Music",5),("Animals",7),("Video Games",6),("Other",4)]
      }

extension UIViewController{
    func addGradient(colors:[CGColor]){
           let gradient = CAGradientLayer()
           gradient.colors = colors
           gradient.locations = [0.0,0.75,1.0]
           gradient.startPoint = CGPoint(x: 0, y: 0)
           gradient.endPoint = CGPoint(x: 0, y: 1)
           gradient.frame = view.frame
           view.layer.insertSublayer(gradient, at: 0)
       }

       func hideKeyboardWhenTappedAround() {
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
           view.addGestureRecognizer(tapGesture)
       }

       @objc func hideKeyboard() {
           view.endEditing(true)
       }

       func addKeyboardNotification(hideSelector:Selector,showSelector:Selector){
           NotificationCenter.default.addObserver(self, selector: showSelector, name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: hideSelector, name: UIResponder.keyboardWillHideNotification, object: nil)
       }
}

extension UIButton {
    func leftImage(image: UIImage, renderMode: UIImage.RenderingMode) {
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: image.size.width / 2)
        self.contentHorizontalAlignment = .left
        self.imageView?.contentMode = .scaleAspectFit
    }

}
