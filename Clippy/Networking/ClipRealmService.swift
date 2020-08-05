//
//  ClipRealmService.swift
//  Clippy
//
//  Created by Ryan Gunn on 8/4/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import Foundation
import RealmSwift

class ClipRealmService {
     let app = RealmApp(id: "shortyclip-sxkkl")

    static let sharedInstance = ClipRealmService()
    var realm:Realm? = nil


    private init(){
        getRealm()

    }

    func getRealm(){
        let user = app.currentUser()
        let partitionValue = "PUBLIC"

        Realm.asyncOpen(configuration: user!.configuration(partitionValue: partitionValue),
            callback: { (maybeRealm, error) in
                guard error == nil else {
                    fatalError("Failed to open realm: \(error!)")
                }
                guard let realm = maybeRealm else {
                    fatalError("realm is nil!")
                }
                self.realm = realm

            })
    }

    func getAllClips(completionHandler:@escaping (RealmResponse<Clip>)->()){
        guard let realm = realm else{
            completionHandler(RealmResponse.Error(error: "No Realm"))
                return
        }
        let clips = realm.objects(Clip.self);
         completionHandler(RealmResponse.Success(response: clips))
    }

    func getCategoryClips(categoryID:Int, completionHandler:@escaping (RealmResponse<Clip>)->()){

        guard let realm = realm else{
            completionHandler(RealmResponse.Error(error: "No Realm"))
                return
        }
        let clips = realm.objects(Clip.self).filter("categoryID == \(categoryID)");
         completionHandler(RealmResponse.Success(response: clips))
        }


       func getFilterClips(searchText:String,completionHandler:@escaping (RealmResponse<Clip>)->()){
        guard let realm = realm else{
               completionHandler(RealmResponse.Error(error: "No Realm"))
                   return
           }
           let clips = realm.objects(Clip.self).filter("title LIKE \(searchText) && tags CONTAINS \(searchText)");
            completionHandler(RealmResponse.Success(response: clips))
        }


       func updateLike(clipID:ObjectId, addLike:Bool, completionHandler:@escaping (RealmResponse<Clip>)->()){

       }

}

public enum RealmResponse <T:Object>{
    case Success(response:Results<T>)
    case Error(error:String)
}

