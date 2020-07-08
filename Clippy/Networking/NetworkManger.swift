//
//  NetworkManger.swift
//  Clippy
//
//  Created by Ryan Gunn on 6/16/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import Foundation



//protocol NetworkService {
//    var baseURL:String{get}
//    func networkRequest<T:Codable>(request:Request,networkBody:T,addToken:Bool, networkCodable:T, completionHandler:@escaping (NetworkResponse)->())
//}

class NetworkService{
    var baseURL:String{
        return "baseURL"
    }

}


public enum RequestParams {

}

public struct Request {
    var path : String

}

