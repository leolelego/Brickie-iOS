//
//  BrickSetAPI.swift
//  BrickSet
//
//  Created by Work on 01/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import Foundation
import Alamofire

var API = BrickSetAPI(collection:UserCollection(),config:Configuration())
struct BrickSetAPI {
    let collection : UserCollection
    let config : Configuration
    
    let apiKey = BrickSetApiKey
    let url = URL(string: "https://brickset.com/api/v3.asmx")!

    
    
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
                    self.config.user = user
                    completion(.success(Void()))
                case  .failure(_):
                    completion(.failure(.badLogin))
            }
        }
    }
    
    func search(text:String,completion: @escaping (Result<Void,APIError>) -> Void){
        
        guard let hash = config.user?.token else {
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
    
    func synchronize(){
        #if DEBUG
        self.collection.setsOwned = load("SampleSets.json")
        #else
        getSets(params: ["owned":"1"]) { (result) in
            switch result {
            case .success(let sets):
                self.collection.setsOwned = sets
            case .failure(let err):
                logerror(err)
            }
        }
        getSets(params: ["wanted":"1"]) { (result) in
            switch result {
            case .success(let sets):
                self.collection.setsWanted = sets
            case .failure(let err):
                logerror(err)
            }
        }
        #endif
       

    }
    
    private func getSets(params:[String:String],completion: @escaping (Result<[LegoSet],Error>) -> Void){
         guard let hash = config.user?.token else {
                    
                    return
                }
                
                let apiParams = APIParams(apiKey: apiKey, userHash: hash, params: params)
                var request = URLRequest(url: url.appendingPathComponent("getSets"))
                request.method = .get
                guard let req = try? URLEncodedFormParameterEncoder().encode(apiParams, into: request) else {return}
//                    if noInternet {
//                        req.cachePolicy = .returnCacheDataDontLoad
//                    }
                    print(req)
                AF.request(req).responseJSON { (response) in
                    switch response.result {
                        case  .success(let value):
                            guard let d = value as? [String:Any], let sets = d["sets"] as? [[String:Any]]  else {
                                log("error : \(value)", .error)
                                return
                            }
                            
                            let decoder = JSONDecoder()
                            guard let mySets = try? decoder.decode([LegoSet].self, fromJSONObject: sets) else {
                                return
                            }
                            completion(.success(mySets))
                
                       
                        case  .failure(let err):
                            logerror(err)

                    }
                }
        
    }
        
        
    
    
}
extension JSONDecoder {
    func decode<T>(_ type: T.Type, fromJSONObject object: Any) throws -> T where T: Decodable {
        return try decode(T.self, from: try JSONSerialization.data(withJSONObject: object, options: []))
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
