//
//  Clip.swift
//  Clippy
//
//  Created by Ryan Gunn on 6/14/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import Foundation


struct ClipWithID:Codable {
    let id:Int
    let title:String
    let duration:Int
    let likes:Int
    let clipURL:String
    let tags:[String]?
    let user:String
    let created:String
    let currentUserLikes:Bool
    let category:Int?
}

struct ClipPost:Codable {
    let title:String
    let duration:Int
    let likes:Int
    let clipURL:String
    let tags:[String]?
    let category:Category?

}

struct ClipListResponse:Codable {
    let count:Int
    let next:String?
    let previous:String?
    let results:[ClipWithID]
}

struct TrendingClipResponse:Codable {
    let clips:[ClipWithID]
}

struct Category:Codable {
    let id:Int
    let name:String
}

