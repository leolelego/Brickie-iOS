//
//  BrickSetAPI.swift
//  BrickSet
//
//  Created by Work on 01/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import Foundation
import Alamofire

var API : BrickSetAPI = {
    let api = BrickSetAPI(collection:UserCollection(),config:Configuration())
    return api
}()

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
                    log("\(value)",.debug)
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
    
    func search(text:String){
           getSets(params: ["query":text]){ sets in
            self.collection.isLoadingData = false
        }
    }
    
    func additionalImages(setID:Int,completion: @escaping (Result<[LegoSetImage],APIError>) -> Void){
        
        let params : [String:Any] = ["apiKey":apiKey,"setID":setID]
        let req = AF.request(url.appendingPathComponent("getAdditionalImages"),parameters: params)
        req.responseJSON { (response) in
            switch response.result {
            case  .success(let value):
                guard let d = value as? [String:Any], let sets = d["additionalImages"] as? [[String:Any]]  else {
                    log("error : \(value)", .error)
                    return
                }
                
                let decoder = JSONDecoder()
                guard let mySets = try? decoder.decode([LegoSetImage].self, fromJSONObject: sets) else {
                    return
                }
                completion(.success(mySets))
                
                
            case  .failure(let err):
                logerror(err)
            }
            
        }
        
    }
    
    func instructions(setID:Int,completion: @escaping (Result<[LegoInstruction],APIError>) -> Void){
        
        let params : [String:Any] = ["apiKey":apiKey,"setID":setID]
        
        AF.request(url.appendingPathComponent("getInstructions"),parameters: params).responseJSON { (response) in
            switch response.result {
            case  .success(let value):
                log("\(value)",.debug)
                
                guard let d = value as? [String:Any], let sets = d["instructions"] as? [[String:Any]]  else {
                    log("error : \(value)", .error)
                    return
                }
                
                let decoder = JSONDecoder()
                guard let mySets = try? decoder.decode([LegoInstruction].self, fromJSONObject: sets) else {
                    return
                }
                completion(.success(mySets))
                
                
            case  .failure(let err):
                logerror(err)
            }
            
        }
        
    }
    
    enum SetCollectionAction {
        case want(Bool)
        case qty(Int)
        case collect(Bool)
        var params : [String:String] {
            switch self {
            case .want(let wanted):
                return ["want": wanted ? "1":"0"]
            case .collect(let col):
                return col ? ["owned":"1","qtyOwned":"1"] : ["owned":"0","qtyOwned":"0"]
            case .qty(let q):
                return ["owned": "\(q < 1 ? "0":"1")","qtyOwned": "\(q)"]
            }
        }
        
        func manage(obj:LegoSet){
            obj.objectWillChange.send()
            API.collection.objectWillChange.send()
            
            switch self {
            case .want(let wanted):
                obj.collection.wanted = wanted
                break
            case .collect(let col):
                obj.collection.qtyOwned = col ? (obj.collection.qtyOwned == 0 ? 1 : obj.collection.qtyOwned) : 0
                obj.collection.owned = col
                break
            case .qty(let q):
                obj.collection.qtyOwned = q
                SetCollectionAction.collect( q < 1 ? false : true).manage(obj: obj)
                break
            }
            
        }
        
    }
    
    
    
    func setCollection(item:LegoSet,action:SetCollectionAction){
        
        guard let hash = config.user?.token else {
            
            return
        }
        
        var apiParams = APIParams(apiKey: apiKey, userHash: hash, params: action.params)
        apiParams.setID = "\(item.setID)"
        var request = URLRequest(url: url.appendingPathComponent("setCollection"))
        request.method = .get
        guard let req = try? URLEncodedFormParameterEncoder().encode(apiParams, into: request) else {return}
        print(req)
        AF.request(req).responseJSON { (response) in
            switch response.result {
            case  .success(let value):
                log("\(value)",.debug)
                action.manage(obj: item)
            case  .failure(let err):
                logerror(err)                
            }
        }
    }
    func synchronizeFigs(){
        
        getMinifigures(params: ["owned":"1"]) { (result) in
            switch result {
            case .success(let items):
                var figs = items
                self.getMinifigures(params: ["wanted":"1"]) { (result) in
                    switch result {
                    case .success(let items):
                        figs.append(contentsOf: items)
                        self.collection.minifigs = Array(Set(figs))
                    case .failure(let err):
                        logerror(err)
                    }
                }
            case .failure(let err):
                logerror(err)
            }
        }
        
        
        
    }
    
    func synchronizeSets(){
        getSets(params: ["owned":"1"]){ sets in
            self.collection.updateOwned(with: sets)
            
        }
        getSets(params: ["wanted":"1"]){ sets in
            self.collection.updateWanted(with: sets)
            
        }
    }
    
    private func getSets(params:[String:String],completion:@escaping ([LegoSet])->Void){
        
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
                    log("getSets : \(value)", .error)
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let mySets = try decoder.decode([LegoSet].self, fromJSONObject: sets)
                    self.collection.append(mySets)
                    completion(mySets)
                } catch {
                    logerror(error)
                    return
                }

            case  .failure(let err):
                logerror(err)
                
            }
        }
        
    }
    
    private func getMinifigures(params:[String:String],completion: @escaping (Result<[LegoMinifig],Error>) -> Void){
        guard let hash = config.user?.token else {
            
            return
        }
        
        let apiParams = APIParams(apiKey: apiKey, userHash: hash, params: params)
        var request = URLRequest(url: url.appendingPathComponent("getMinifigCollection"))
        request.method = .get
        guard let req = try? URLEncodedFormParameterEncoder().encode(apiParams, into: request) else {return}
        //                    if noInternet {
        //                        req.cachePolicy = .returnCacheDataDontLoad
        //                    }
        print(req)
        AF.request(req).responseJSON { (response) in
            switch response.result {
            case  .success(let value):
                guard let d = value as? [String:Any], let sets = d["minifigs"] as? [[String:Any]]  else {
                    log("error : \(value)", .error)
                    return
                }
                
                let decoder = JSONDecoder()
                guard let mySets = try? decoder.decode([LegoMinifig].self, fromJSONObject: sets) else {
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
    var setID : String = ""
    let params : [String:String]
    enum CodingKeys: String, CodingKey {
        case apiKey
        case userHash
        case setID
        case params
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(apiKey, forKey: .apiKey)
        try container.encode(userHash, forKey: .userHash)
        try container.encode(setID, forKey: .setID)
        
        var paramsList = [String]()
        
        for (key,value) in params {
            paramsList.append("\"\(key)\":\"\(value)\"")
        }
        let paramStr = "{" + paramsList.joined(separator: ",") + "}"
        
        try container.encode(paramStr, forKey: .params)
        
        
        
    }
    
}
