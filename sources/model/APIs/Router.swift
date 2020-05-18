//
//  File.swift
//  BrickSet
//
//  Created by Work on 12/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import Foundation
enum APIRouter<T:Any> {
    
    // MARK: Base
    case login(String,String)
    
    // MARK: Get Sets Data
    case ownedSets(String)
    case wantedSets(String)
    case searchSets(String,String)
    
    // MARK: Set Sets Data
    case setWanted(String,LegoSet,Bool)
    case setOwned(String,LegoSet,Bool)
    case setQty(String,LegoSet,Int)
    
    // MARK: Get Sets Details
    case setInstructions(Int)
    case additionalImages(Int)
    
    // MARK: Get Sets Data
    case ownedFigs(String)
    case wantedFigs(String)
    case searchMinifigs(String,String)
    
    var url : URL? {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(method), resolvingAgainstBaseURL: false)
            else {return nil}
        components.queryItems = querys
        return components.url
    }
    var baseURL : URL {
        return URL(string: "https://brickset.com/api/v3.asmx")!
    }
    
    var method : String {
        switch self {
        case .login: return "login"
        case .setInstructions: return "getInstructions"
        case .additionalImages: return "getAdditionalImages"
        case .ownedSets,.wantedSets,.searchSets : return "getSets"
        case .setWanted,.setOwned,.setQty: return "setCollection"
        case .ownedFigs,.wantedFigs,.searchMinifigs: return "getMinifigCollection"
            
        }
    }
    
    var subkey : String {
        switch self {
        case .login: return "hash"
        case .setInstructions: return "instructions"
        case .additionalImages:  return "additionalImages"
        case .ownedSets,.wantedSets,.searchSets : return "sets"
        case .setWanted,.setOwned,.setQty: return "status"
        case .ownedFigs,.wantedFigs,.searchMinifigs: return "minifigs"

            
        }
    }
    var querys : [URLQueryItem]? {
        switch self {
        case .login(let u, let p):
            return [
                URLQueryItem(name: "apiKey", value: BrickSetApiKey),
                URLQueryItem(name: "username", value: u),
                URLQueryItem(name: "password", value: p)
            ]
            
        case .setInstructions(let setId),.additionalImages(let setId):
            return [
                URLQueryItem(name: "apiKey", value: BrickSetApiKey),
                URLQueryItem(name: "setID", value: String(setId)),
            ]
        case .ownedSets(let hash),.ownedFigs(let hash) : return [
            URLQueryItem(name: "apiKey", value: BrickSetApiKey),
            URLQueryItem(name: "userHash", value: hash),
            URLQueryItem(name: "params", value: "{owned:1}"),
            ]
        case .wantedSets(let hash),.wantedFigs(let hash) : return [
            URLQueryItem(name: "apiKey", value: BrickSetApiKey),
            URLQueryItem(name: "userHash", value: hash),
            URLQueryItem(name: "params", value: "{wanted:1}"),
            ]
        case .searchSets(let hash, let search),.searchMinifigs(let hash, let search) : return [
            URLQueryItem(name: "apiKey", value: BrickSetApiKey),
            URLQueryItem(name: "userHash", value: hash),
            URLQueryItem(name: "params", value: "{query:\"\(search)\"}"),
            ]
        case .setWanted(let hash,let set, let want) : return [
            URLQueryItem(name: "apiKey", value: BrickSetApiKey),
            URLQueryItem(name: "userHash", value: hash),
            URLQueryItem(name: "setID", value: String(set.setID)),
            URLQueryItem(name: "params", value: "{want:\(want ? 1:0)}")
            ]
        case .setOwned(let hash,let set, let col) : return [
            URLQueryItem(name: "apiKey", value: BrickSetApiKey),
            URLQueryItem(name: "userHash", value: hash),
            URLQueryItem(name: "setID", value: String(set.setID)),
            URLQueryItem(name: "params", value: col ? "{owned:1,qtyOwned:1}" : "{owned:0,qtyOwned:0}" )
            ]
        case .setQty(let hash,let set, let qty) : return [
            URLQueryItem(name: "apiKey", value: BrickSetApiKey),
            URLQueryItem(name: "userHash", value: hash),
            URLQueryItem(name: "setID", value: String(set.setID)),
            URLQueryItem(name: "params", value: "{owned:\(qty < 1 ? 0 : 1),qtyOwned:\(qty)}")
            ]
        }
        
    }
    

    
}

extension APIRouter {
    private func response(completion: @escaping (Result<Any,Error>) -> Void){
        guard let u = url
            else {
                completion(.failure(APIError.invalid))
                return
                
        }
        log("URL CALL: \(u)")
        URLSession.shared.dataTask(with: u){ data, response, error in
            guard error == nil else {
                logerror(error)
                completion(.failure(error!))
                return
                
            }
            guard let d = data,
                let jsonObj = try? JSONSerialization.jsonObject(with: d, options: [])
                else {
                    completion(.failure(APIError.invalid))
                    return
            }
            completion(.success(jsonObj))
            
        }.resume()
        
    }
    
    func responseJSON(completion: @escaping (Result<T,Error>) -> Void){
        response { response in
            switch response {
            case .failure(let err):
                logerror(err)
                completion(.failure(err))
                break
            case .success(let jsonObj):
                guard let dict = jsonObj as? [String:Any],
                    let items = dict[self.subkey] as? T
                    else {
                        completion(.failure(APIError.invalid))
                        return
                }
                completion(.success(items))
                break
            }
        }
    }
    
    func decode<C:Codable>(ofType: C.Type,completion: @escaping (C) -> Void){
        responseJSON { response in
            switch response{
            case .success(let object):
                do {
                    
                    let json = try JSONSerialization.data(withJSONObject: object, options: [])
                    let items = try JSONDecoder().decode(ofType.self, from: json)
                    completion(items)
                } catch {
                    logerror(error)
                }
                break
            case .failure(_):
                break // logged before nobody care
            }
            
        }
    }
}

