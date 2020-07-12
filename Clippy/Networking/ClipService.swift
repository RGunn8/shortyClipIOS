//
//  ClipService.swift
//  Clippy
//
//  Created by Ryan Gunn on 6/16/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import Foundation
import Alamofire

class ClipService{
    var baseURL = "f8b9a2c55132.ngrok.io"
    static let shared = ClipService()
    private init(){}

    func getAllClips(pageNumber:Int = 1,completionHandler:@escaping (NetworkResponse)->()){

        guard let url = getURL(path: "/api/v1/clips/",pageNumber: pageNumber) else {
            completionHandler(NetworkResponse.Error(error: "Invalid URL"))
            return
        }
        AF.request(url).responseDecodable(of: ClipListResponse.self) { (response) in
            if let error = response.error{
                print(error)
                completionHandler(NetworkResponse.Error(error: error.localizedDescription))
                    return
            }

            if let clips = response.value{
                completionHandler(NetworkResponse.Success(response: clips))
            }
        }
    }

    func getCategoryClips(categoryID:Int,pageNumber:Int = 1, completionHandler:@escaping (NetworkResponse)->()){

         guard let url = getURL(path: "/api/v1/clip/category/\(categoryID)",pageNumber: pageNumber) else {
             completionHandler(NetworkResponse.Error(error: "Invalid URL"))
             return
         }
         AF.request(url).responseDecodable(of: ClipListResponse.self) { (response) in
             if let error = response.error{
                 print(error)
                 completionHandler(NetworkResponse.Error(error: error.localizedDescription))
                     return
             }

             if let clips = response.value{
                completionHandler(NetworkResponse.Success(response: clips))
             }
         }
     }




    func getFilterClips(searchText:String,pageNumber:Int=1,completionHandler:@escaping (NetworkResponse)->()){
            guard let url = getURL(path: "/api/v1/clips/",searchString: searchText,pageNumber: pageNumber) else {
                      completionHandler(NetworkResponse.Error(error: "Invalid URL"))
                      return
                  }

                  AF.request(url).responseDecodable(of: ClipListResponse.self) { (response) in
                      if let error = response.error{
                          completionHandler(NetworkResponse.Error(error: error.localizedDescription))
                              return
                      }

                      if let clips = response.value{
                          completionHandler(NetworkResponse.Success(response: clips))
                      }
                  }
    }

    func updateLike(clipID:Int, addLike:Bool, completionHandler:@escaping (NetworkResponse)->()){
        guard let url = getURL(path: "/api/v1/clips/\(clipID)/like") else {
                   completionHandler(NetworkResponse.Error(error: "Invalid URL"))
                   return
               }

        let defaults = UserDefaults.standard
                  defaults.object(forKey: "token")
                  let tokenString =  defaults.object(forKey: "token") as? String
                  guard let token = tokenString else{
                    completionHandler(NetworkResponse.Error(error: "No Token"))
                    return
                }

        let header = HTTPHeader(name: "Authorization", value: "Token \(token)")
        let dataTypeHeader = HTTPHeader(name: "dataType", value: "json")
        let contentTypeHeadper = HTTPHeader(name:"contentType",value: "application/json")
        var method = HTTPMethod.post
        if(!addLike){
            method = HTTPMethod.delete
        }
        
        AF.request(url,method: method,headers: HTTPHeaders([header,dataTypeHeader,contentTypeHeadper])).response {response in
            if let error = response.error{
                completionHandler(NetworkResponse.Error(error: error.localizedDescription))
                return
            }
            if let code = response.response?.statusCode{
                if code == 201 || code == 200 {
                    completionHandler(NetworkResponse.Success(response: true))
                }
            }

        }
    }

    func getPopularSearch(completionHandler:@escaping (NetworkResponse)->()){
        guard let url = getURL(path: "/api/v1/popluarSearch") else {
                              completionHandler(NetworkResponse.Error(error: "Invalid URL"))
                              return
                          }
        AF.request(url).responseDecodable(of: SearchItemResponse.self) { (response) in
                       if let error = response.error{
                        completionHandler(NetworkResponse.Error(error: error.localizedDescription))
                               return
                       }

                       if let searchItem = response.value{
                           completionHandler(NetworkResponse.Success(response: searchItem))
                       }
                   }
    }

    func addSearchItem(searchItem:String){
        guard let url = getURL(path: "/api/v1/searchItem") else {

                       return
                   }

        let searchItemPost = SearchItemPost(searchItem: searchItem)

        let request = AF.request(url,method: .post,parameters:searchItemPost,encoder: JSONParameterEncoder.default)
        request.response {response in
                   if let error = response.error{
                    print(error)
                       return
                   }
        }

    }

    func addClip(clip:ClipPost, completionHandler:@escaping (NetworkResponse)->()){
        guard let url = getURL(path: "/api/v1/clip/new") else {
                   completionHandler(NetworkResponse.Error(error: "Invalid URL"))
                   return
               }



        let defaults = UserDefaults.standard
                  defaults.object(forKey: "token")
                  let tokenString =  defaults.object(forKey: "token") as? String

                  guard let token = tokenString else{
                    completionHandler(NetworkResponse.Error(error: "No Token"))
                    return
                  }

        let header = HTTPHeader(name: "Authorization", value: "Token \(token)")
        let request = AF.request(url,method: .post,parameters: clip,encoder: JSONParameterEncoder.default,headers: HTTPHeaders([header]))


        request.response {response in
            if let error = response.error{
                completionHandler(NetworkResponse.Error(error: error.localizedDescription))
                return
            }
            if let code = response.response?.statusCode{
                if code == 201 {
                    completionHandler(NetworkResponse.Success(response: true))
                }
            }
        }

    }

    func getURL(path:String,searchString:String? = nil,pageNumber:Int? = nil) -> URL?{
        var components = URLComponents()
        components.scheme = "http"
        components.host = baseURL
        components.path = path
        var queryItems = [URLQueryItem]()
        if let searchString = searchString{
            let queryItem = URLQueryItem(name: "search", value: searchString)
            queryItems.append(queryItem)
        }
        if let pageNumber = pageNumber {
            let queryItem = URLQueryItem(name: "page", value: String(pageNumber))
              queryItems.append(queryItem)
        }

        components.queryItems = queryItems

        return components.url
    }
}



public enum NetworkResponse {
    case Success(response:Codable)
    case Error(error:String)
}
