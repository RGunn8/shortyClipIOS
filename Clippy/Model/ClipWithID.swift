//
//  Clip.swift
//  Clippy
//
//  Created by Ryan Gunn on 6/14/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import Foundation
import RealmSwift


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

    func getTagLabel() -> [String]{
        guard let  tags = tags else {
            return []
        }
        if tags.isEmpty {
            return []
        }else{
            var clipTag:[String] = []
            for tag in tags {
                clipTag.append("#\(tag)")
            }
            return clipTag
        }
    }

}

class User : Object {
    @objc dynamic var _id = ObjectId.generate()
    @objc dynamic var username = ""
    @objc dynamic var email = ""
     dynamic var favTags:List<String> = List<String>()
     dynamic var favClips:List<Clip> = List<Clip>()
//    @objc dynamic var syncUser:RLMSyncUser? = nil
    let clips = List<Clip>()

    override static func primaryKey() -> String? {
           return "_id"
       }

}

class Clip :Object {
    @objc dynamic var _id:ObjectId = ObjectId.generate()
     @objc dynamic var title = ""
     @objc dynamic var duration = 0
     @objc dynamic var likes = 0
     @objc dynamic var clipURL = ""
    @objc dynamic var _partitionKey = "PUBLIC"
    @objc dynamic var username = ""
    @objc dynamic var userId:ObjectId? = nil
     @objc dynamic var created:Date = Date()
     @objc dynamic var currentUserLikes:Bool = false
     @objc dynamic var clipCategory:Int = 0
     var tags:List<String> = List<String>()

    override static func primaryKey() -> String? {
           return "_id"
       }

    func convertCreatedDateToString() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMMM dd,yyyy"
        return dateFormatterPrint.string(from: created)

    }

    func getTagLabel() -> [String]{

        if tags.isEmpty {
            return []
        }else{
            var clipTag:[String] = []
            for tag in tags {
                clipTag.append("#\(tag)")
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

struct ClipDetailResponse:Codable {
    let clip:ClipWithID
    let relatedClip:[ClipWithID]?
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
