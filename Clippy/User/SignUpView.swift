//
//  SignUpView.swift
//  Clippy
//
//  Created by Ryan Gunn on 7/12/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import UIKit

 class SignUpView: UIView {
    let signInLabel = UILabel()
    let userNameTextView = UITextView()
    let passwordTextView = UITextView()
    let confirmPasswordTextView = UITextView()
    let signInButton = UIButton()
    var scrollView = UIScrollView()
     var keyboardHeight = 0


    override init(frame: CGRect) {
      super.init(frame: frame)
      self.backgroundColor = UIColor.white
        setUpView()

    }


    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }

    func setUpView(){
        setUpScrollView()
        setUpSignInLabel()
        setUpUserNameTextView()
        setUpPasswordTextView()
        setUpConfirmPasswordTextView()
        setUpSignUpButton()
        self.backgroundColor = .red
    }

    func setUpScrollView(){
        scrollView.addCodeConstraints(parentView: self, constraints: [
            scrollView.topAnchor.constraint(equalTo: safe().topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safe().leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safe().trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safe().bottomAnchor)
        ])
    }

    func setUpSignInLabel(){
        signInLabel.text = "Login"
        signInLabel.addCodeConstraints(parentView: scrollView, constraints: [
            signInLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            signInLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 30),
            signInLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,constant: -30)
        ])
        signInLabel.textAlignment = .center
    }

    func setUpUserNameTextView(){
        userNameTextView.addCodeConstraints(parentView: scrollView, constraints: [
            userNameTextView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            userNameTextView.leadingAnchor.constraint(equalTo: safe().leadingAnchor, constant: 30),
            userNameTextView.trailingAnchor.constraint(equalTo: safe().trailingAnchor, constant: -30),
            userNameTextView.heightAnchor.constraint(equalToConstant: 25)
        ])
        userNameTextView.backgroundColor = .black
    }

    func setUpPasswordTextView(){
        passwordTextView.addCodeConstraints(parentView: scrollView, constraints: [
            passwordTextView.topAnchor.constraint(equalTo: userNameTextView.bottomAnchor,constant: 15),
            passwordTextView.leadingAnchor.constraint(equalTo: userNameTextView.leadingAnchor),
            passwordTextView.trailingAnchor.constraint(equalTo: userNameTextView.trailingAnchor),
            passwordTextView.heightAnchor.constraint(equalToConstant: 25)
        ])
    }

    func setUpConfirmPasswordTextView(){
        confirmPasswordTextView.addCodeConstraints(parentView: scrollView, constraints: [
            confirmPasswordTextView.topAnchor.constraint(equalTo: passwordTextView.bottomAnchor,constant: 8),
            confirmPasswordTextView.leadingAnchor.constraint(equalTo: passwordTextView.leadingAnchor),
            confirmPasswordTextView.trailingAnchor.constraint(equalTo: passwordTextView.trailingAnchor),
             confirmPasswordTextView.heightAnchor.constraint(equalToConstant: 25)

        ])
    }

    func setUpSignUpButton(){
        signInButton.addCodeConstraints(parentView: scrollView, constraints: [
            signInButton.bottomAnchor.constraint(equalTo: safe().bottomAnchor, constant: -30),
            signInButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        signInButton.setTitle("Sign In", for: .normal)
    }

   


}
