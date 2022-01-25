//
//  File.swift
//  BrickSet
//
//  Created by Work on 12/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import Foundation
let pageSizeSearch = 150
let pageSizeSet = 350

enum APIRouter<T:Any> {
    
    // MARK: Base
    case login(String,String)
    
    // MARK: Get Sets Data
    case ownedSets(String,Int)
    case wantedSets(String,Int)
    case searchSets(String,String,Int)
    case searchSetsTheme(String,String,Int)
    case searchSetsSubTheme(String,String,Int)
    case searchSetsYear(String,String,Int)
    
    // MARK: Set Sets Data
    case setWanted(String,LegoSet,Bool)
    //    case setOwned(String,LegoSet,Bool) // Useless as it's done form the server by updating the QTY
    case setQty(String,LegoSet,Int)
    case setNotes(String,LegoSet,String)
    // MARK: Get Sets Details
    case setInstructions(Int)
    case additionalImages(Int)
    
    // MARK: Get Sets Data
    case ownedFigs(String)
    case wantedFigs(String)
    case searchMinifigs(String,String)
    
    case minifigWanted(String,LegoMinifig,Bool)
    case minifigQty(String,LegoMinifig,Int)
    case minifigNotes(String,LegoMinifig,String)
    
    // MARK: Get Theme Theme and Subtheme
    case themes
    case subthemes(String)
    
    // Mark Notes
    case getMinifigNotes(String)
    
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
        case .ownedSets,.wantedSets,.searchSets,.searchSetsTheme,.searchSetsSubTheme,.searchSetsYear : return "getSets"
        case .setWanted,.setQty,.setNotes: return "setCollection"
        case .ownedFigs,.wantedFigs,.searchMinifigs: return "getMinifigCollection"
        case .minifigWanted,.minifigQty,.minifigNotes: return "setMinifigCollection"
        case .themes : return "getThemes"
        case .subthemes : return "getSubthemes"
        case .getMinifigNotes : return "getUserMinifigNotes"
            
        }
    }
    
    var subkey : String {
        switch self {
        case .login: return "hash"
        case .setInstructions: return "instructions"
        case .additionalImages:  return "additionalImages"
        case .ownedSets,.wantedSets,.searchSets,.searchSetsTheme,.searchSetsSubTheme,.searchSetsYear : return "sets"
        case .ownedFigs,.wantedFigs,.searchMinifigs: return "minifigs"
        case .setWanted,.setQty,.minifigWanted,.minifigQty,.setNotes,.minifigNotes: return "status"
        case .themes: return "themes"
        case .subthemes: return "subthemes"
        case .getMinifigNotes : return "userMinifigNotes"

            
            
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
        case .ownedSets(let hash, let page): return [
            URLQueryItem(name: "apiKey", value: BrickSetApiKey),
            URLQueryItem(name: "userHash", value: hash),
            URLQueryItem(name: "params", value: "{owned:1,pageNumber:\(page),pageSize:\(pageSizeSet)}"),
            ]
        case .ownedFigs(let hash) : return [
            URLQueryItem(name: "apiKey", value: BrickSetApiKey),
            URLQueryItem(name: "userHash", value: hash),
            URLQueryItem(name: "params", value: "{owned:1}"),
            ]
        case .wantedSets(let hash, let page) : return [
            URLQueryItem(name: "apiKey", value: BrickSetApiKey),
            URLQueryItem(name: "userHash", value: hash),
            URLQueryItem(name: "params", value: "{wanted:1,pageNumber:\(page),pageSize:\(pageSizeSet)}"),
            ]
        case .wantedFigs(let hash) : return [
            URLQueryItem(name: "apiKey", value: BrickSetApiKey),
            URLQueryItem(name: "userHash", value: hash),
            URLQueryItem(name: "params", value: "{wanted:1}"),
            ]
        case .searchSets(let hash, let search, let page) : return [
            URLQueryItem(name: "apiKey", value: BrickSetApiKey),
            URLQueryItem(name: "userHash", value: hash),
            URLQueryItem(name: "params", value: "{query:\"\(search)\",pageNumber:\(page),pageSize:\(pageSizeSearch)}"),
            ]
        case .searchSetsTheme(let hash, let search, let page) : return [
            URLQueryItem(name: "apiKey", value: BrickSetApiKey),
            URLQueryItem(name: "userHash", value: hash),
            URLQueryItem(name: "params", value: "{theme:\"\(search)\",pageNumber:\(page),pageSize:\(pageSizeSearch)}"),
            ]
        case .searchSetsSubTheme(let hash, let search, let page) : return [
            URLQueryItem(name: "apiKey", value: BrickSetApiKey),
            URLQueryItem(name: "userHash", value: hash),
            URLQueryItem(name: "params", value: "{subtheme:\"\(search)\",pageNumber:\(page),pageSize:\(pageSizeSearch)}"),
            ]
        case .searchSetsYear(let hash, let search, let page) : return [
            URLQueryItem(name: "apiKey", value: BrickSetApiKey),
            URLQueryItem(name: "userHash", value: hash),
            URLQueryItem(name: "params", value: "{year:\"\(search)\",pageNumber:\(page),pageSize:\(pageSizeSearch)}"),
            ]
        case .searchMinifigs(let hash, let search) : return [
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
        case .setQty(let hash,let set, let qty) : return [
            URLQueryItem(name: "apiKey", value: BrickSetApiKey),
            URLQueryItem(name: "userHash", value: hash),
            URLQueryItem(name: "setID", value: String(set.setID)),
            URLQueryItem(name: "params", value: "{qtyOwned:\(qty)}") //owned:\(qty < 1 ? 0 : 1),
            ]
        case .setNotes(let hash,let set, let notes) : return [
            URLQueryItem(name: "apiKey", value: BrickSetApiKey),
            URLQueryItem(name: "userHash", value: hash),
            URLQueryItem(name: "setID", value: String(set.setID)),
            URLQueryItem(name: "params", value: "{notes:\"\(notes.isEmpty ? " " : notes)\"}") //owned:\(qty < 1 ? 0 : 1),
            ]
        case .minifigWanted(let hash,let minifig, let want) : return [
            URLQueryItem(name: "apiKey", value: BrickSetApiKey),
            URLQueryItem(name: "userHash", value: hash),
            URLQueryItem(name: "minifigNumber", value: minifig.minifigNumber),
            URLQueryItem(name: "params", value: "{want:\(want ? 1:0),qtyOwned:\(minifig.ownedLoose)}")
            ]
        case .minifigQty(let hash,let minifig, let qty) : return [
            URLQueryItem(name: "apiKey", value: BrickSetApiKey),
            URLQueryItem(name: "userHash", value: hash),
            URLQueryItem(name: "minifigNumber", value: minifig.minifigNumber),
            URLQueryItem(name: "params", value: "{want:\(minifig.wanted ? 1 : 0),qtyOwned:\(qty)}")
            ]
        case .minifigNotes(let hash,let minifig, let notes) : return [
            URLQueryItem(name: "apiKey", value: BrickSetApiKey),
            URLQueryItem(name: "userHash", value: hash),
            URLQueryItem(name: "minifigNumber", value: minifig.minifigNumber),
            URLQueryItem(name: "params", value: "{notes:\"\(notes.isEmpty ? " " : notes)\"}")
            ]
        case .themes : return [
            URLQueryItem(name: "apiKey", value: BrickSetApiKey),
            ]
        case .subthemes(let theme) : return [
            URLQueryItem(name: "apiKey", value: BrickSetApiKey),
            URLQueryItem(name: "theme", value: theme),
            ]
        case .getMinifigNotes(let hash) : return [
            URLQueryItem(name: "apiKey", value: BrickSetApiKey),
            URLQueryItem(name: "userHash", value: hash),
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
                guard let dict = jsonObj as? [String:Any]
                    else {
                        completion(.failure(APIError.invalid))
                        return
                }
                
                if let items = dict[self.subkey] as? T {
                    completion(.success(items))
                } else if let mess = dict["message"] as? String {
                    if mess.contains("Invalid user hash") {
                        completion(.failure(APIError.invalidUserHash))
                    } else if mess.contains("API limit exceeded") {
                        completion(.failure(APIError.apiLimitExceeded))
                    } else {
                        completion(.failure(APIError.badData))
                    }
                } else {
                    completion(.failure(APIError.malformed))

                }
                break

            }
        }
    }
    
    func decode<C:Codable>(ofType: C.Type,completion: @escaping (Result<C,Error>) -> Void /*@escaping (C) -> Void*/){
        responseJSON { response in
            switch response{
            case .success(let object):
                do {
                    
                    let json = try JSONSerialization.data(withJSONObject: object, options: [])
                    let items = try JSONDecoder().decode(ofType.self, from: json)
                    
                    completion(.success(items))
                } catch let DecodingError.dataCorrupted(context) {
                    log("\(context)")
                } catch let DecodingError.keyNotFound(key, context) {
                    
                    log("Key '\(key)' not found: \(context.debugDescription)")
                    log("codingPath: \(context.codingPath)")
                } catch let DecodingError.valueNotFound(value, context) {
                    log("Value '\(value)' not found: \(context.debugDescription)")
                    log("codingPath: \(context.codingPath)" )
                } catch let DecodingError.typeMismatch(type, context)  {
                    log("Type '\(type)' mismatch: \(context.debugDescription)")
                    log("codingPath: \(context.codingPath)")
                } catch {
                    logerror(error)
                }
                break
            case .failure(let err):
                completion(.failure(err))

                break // logged before nobody care
            }
            
        }
    }
    

}

