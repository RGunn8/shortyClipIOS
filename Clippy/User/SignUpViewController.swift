//
//  SignUpViewController.swift
//  Clippy
//
//  Created by Ryan Gunn on 7/12/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    var signUpView:SignUpView!

    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView = SignUpView(frame: self.view.frame)
        self.view.addSubview(signUpView)
        addGradient(colors: [UIColor.electricPurple.cgColor,UIColor.oxfordBlue.cgColor])
        addKeyboardNotification(hideSelector: #selector(keyBoardWillHide(notification:)), showSelector: #selector(keyboardWillShow(notification:)))
             hideKeyboardWhenTappedAround()
    }

    @objc func keyboardWillShow(notification: NSNotification){
           adjustScrollViewForKeyboard(isShowing: true, notification: notification)
       }

       @objc func keyBoardWillHide(notification: NSNotification){
           adjustScrollViewForKeyboard(isShowing: false, notification: notification)
       }

       func adjustScrollViewForKeyboard(isShowing: Bool, notification: NSNotification){
//           let userInfo = notification.userInfo ?? [:]
//           let keyboardFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
//           let adjustment = (keyboardFrame.height  * (isShowing ? 1:0))
//           let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: adjustment + 45, right: 0)
//        signUpView.scrollView.contentInset = contentInset
//        signUpView.scrollView.scrollIndicatorInsets = contentInset
       }
    deinit {
           NotificationCenter.default.removeObserver(self)
       }


}
