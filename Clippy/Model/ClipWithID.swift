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

    func convertCreatedDateToString() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMMM dd,yyyy"

        if let date = dateFormatterGet.date(from: created) {
            return dateFormatterPrint.string(from: date)
        } else {
          return ""
        }
    }

    func getTagLabel() -> String{
        guard let  tags = tags else {
            return ""
        }
        if tags.isEmpty {
            return ""
        }else{
            var clipTag = ""
            for tag in tags {
                clipTag += "#\(tag) "
            }
            return clipTag
        }
    }

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

struct SearchItemPost:Codable {
    let searchItem:String
}

struct SearchItem:Codable {
    let searchItem:String
    let count:Int
}

struct SearchItemResponse:Codable {
    let searchItems:[SearchItem]
}
