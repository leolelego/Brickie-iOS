//
//  BrickSetAPI.swift
//  BrickSet
//
//  Created by Work on 01/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import Foundation
import Alamofire

let API = BrickSetAPI()
struct BrickSetAPI {

    var url = URL(string: "https://brickset.com/api/v3.asmx")!

    
    
    func login(username:String, password:String,completion: @escaping (Result<Void,APIError>) -> Void){
        let params = ["apiKey":apiKey,"username":username,"password":password]
        
        AF.request(url.appendingPathComponent("login"),parameters: params)
            
            .responseJSON { (response) in
            switch response.result {
                case  .success(let value):
                    guard let d = value as? [String:Any], let hash = d["hash"] as? String else {
                        completion(.failure(.badLogin))
                        return

                    }
                    let user = User(username: username, token: hash)
                    AppConfig.user = user
                    completion(.success(Void()))
                case  .failure(_):
                    completion(.failure(.badLogin))
            }
        }
    }
    
    func search(text:String,completion: @escaping (Result<Void,APIError>) -> Void){
        
        guard let hash = AppConfig.user?.token else {
            return
        }
        let params : [String:Any] = ["apiKey":apiKey,"userHash":hash,"params":[
            "query": text
            ]]
        AF.request(url.appendingPathComponent("getSets"),parameters: params).responseJSON { (response) in
            switch response.result {
                case  .success(let value):
                    guard let d = value as? [String:Any], let status = d["status"] as? String, status != "error" else {
                        completion(.failure(.malformed))
                        return
                    }
                    
        
               
                    completion(.success(Void()))
                case  .failure(_):
                    completion(.failure(.badLogin))
            }
        }
    }
    
    func synchronizeSets(){
        
        guard let hash = AppConfig.user?.token else {
            return
        }
        
//        let paramss = APIParams(apiKey: apiKey, userHash: hash, params: "{\"owned\": \"1\"}")
        let paramss = APIParams(apiKey: apiKey, userHash: hash, params: ["owned":"1"])
        var request = URLRequest(url: url.appendingPathComponent("getSets"))
        request.method = .get
        do {
        request = try URLEncodedFormParameterEncoder().encode(paramss, into: request)

            print(request)
        AF.request(request).responseJSON { (response) in
            switch response.result {
                case  .success(let value):
                    guard let d = value as? [String:Any], let sets = d["sets"] as? [[String:Any]]  else {
                        log("error : \(value)", .error)
                        return
                    }
                
                print(sets)
        
               
                case  .failure(let err):
                    logerror(err)

            }
        }
        } catch {
            
        }
    }
        
        
    
    
}

//enum APIConsc

struct APIParams : Encodable {
    
    let apiKey : String
    let userHash : String
    let params : [String:String]
    enum CodingKeys: String, CodingKey {
           case apiKey
           case userHash
           case params
       }
    func encode(to encoder: Encoder) throws {
           var container = encoder.container(keyedBy: CodingKeys.self)
           try container.encode(apiKey, forKey: .apiKey)
           try container.encode(userHash, forKey: .userHash)
        
        
        var paramStr = "{"
        
        for (key,value) in params {
            paramStr += "\"\(key)\":\"\(value)\""
        }
        paramStr += "}"
        
        try container.encode(paramStr, forKey: .params)



       }
    
}
