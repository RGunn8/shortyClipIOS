//
//  UserService.swift
//  Clippy
//
//  Created by Ryan Gunn on 7/26/20.
//  Copyright © 2020 Ryan Gunn. All rights reserved.
//

import Foundation
import Alamofire

class UserService{
    var baseURL = "9c334a2f1236.ngrok.io"
    static let shared = UserService()
    private init(){}

    func login(userName:String,password:String,completionHandler:@escaping (NetworkResponse)->()){

        guard let url = getURL(path: "/api/v1/user/login") else {
            completionHandler(NetworkResponse.Error(error: "Invalid URL"))
            return
        }
        let loginPost = UserLoginPost(username: userName, password: password)
       let request = AF.request(url,method: .post,parameters:loginPost,encoder: JSONParameterEncoder.default)

          request.responseDecodable(of: TokenResponse.self) {response in
                  if let error = response.error{
                      completionHandler(NetworkResponse.Error(error: error.localizedDescription))
                      return
                  }
                  if let code = response.response?.statusCode{
                      if code == 201 {
                        let defaults = UserDefaults.standard
                        if let tokenResponse = response.value{
                            defaults.set(tokenResponse.token, forKey: "token")
                             completionHandler(NetworkResponse.Success(response: true))
                        }

                      }
                  }
              }
    }

    func register(userName:String,password:String,completionHandler:@escaping (NetworkResponse)->()){

          guard let url = getURL(path: "/api/v1/user/register") else {
              completionHandler(NetworkResponse.Error(error: "Invalid URL"))
              return
          }
          let loginPost = UserLoginPost(username: userName, password: password)
         let request = AF.request(url,method: .post,parameters:loginPost,encoder: JSONParameterEncoder.default)
            request.responseDecodable(of: UserRegisterResponse.self) {response in
                    if let error = response.error{
                        completionHandler(NetworkResponse.Error(error: error.localizedDescription))
                        return
                    }
                    if let code = response.response?.statusCode{
                        if code == 201 {
                          let defaults = UserDefaults.standard
                          if let userResponse = response.value{
                              defaults.set(userResponse.token, forKey: "token")
                            defaults.set(userResponse.id, forKey: "id")
                            defaults.set(userResponse.userName, forKey: "username")
                               completionHandler(NetworkResponse.Success(response: true))
                          }

                        }
                    }
                }
      }

    func userInfo(id:Int,completionHandler:@escaping (NetworkResponse)->()){

            guard let url = getURL(path: "/api/v1/user/\(id)") else {
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
             AF.request(url,headers: [header]).responseDecodable(of: UserResponse.self) { (response) in
                      if let error = response.error{
                          print(error)
                          completionHandler(NetworkResponse.Error(error: error.localizedDescription))
                              return
                      }

                      if let user = response.value{
                          completionHandler(NetworkResponse.Success(response: user))
                      }
                  }
        }

    func userFavs(id:Int,completionHandler:@escaping (NetworkResponse)->()){

            guard let url = getURL(path: "/api/v1/user/favorites") else {
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
             AF.request(url,headers: [header]).responseDecodable(of: UserFavorites.self) { (response) in
                      if let error = response.error{
                          print(error)
                          completionHandler(NetworkResponse.Error(error: error.localizedDescription))
                              return
                      }

                      if let user = response.value{
                          completionHandler(NetworkResponse.Success(response: user))
                      }
                  }
        }



    func getURL(path:String) -> URL?{
          var components = URLComponents()
          components.scheme = "http"
          components.host = baseURL
          components.path = path
          return components.url
      }

}
