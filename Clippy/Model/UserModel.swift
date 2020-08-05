//
//  UserModel.swift
//  Clippy
//
//  Created by Ryan Gunn on 7/26/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import Foundation

struct UserLoginPost:Codable {
    let username:String
    let password:String
}

struct TokenResponse:Codable{
    let token:String
}

struct UserRegisterResponse:Codable {
    let id:Int
    let userName:String
    let clip:[ClipWithID]
    let token:String
    let password:String
}

struct UserResponse:Codable {
    let id:Int
    let userName:String
    let clip:[ClipWithID]
}

struct UserFavorites:Codable {
    let clip:[ClipWithID]
}
