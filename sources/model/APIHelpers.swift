//
//  APIHelpers.swift
//  BrickSet
//
//  Created by Work on 01/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import Foundation
import Alamofire

enum APIError : Error {
    case unknown
    case badLogin
    case malformed
    case invalid

    var localizedDescription: String {
        switch self {
        case .badLogin:
            return "error.badlogin".ls
        default:
            return "error.unknown".ls
        }
    }
}

// MARK: Alamofire Router
enum BrickSetAPIRouter: URLRequestConvertible {
    case login([String: String])
    case search([String: Any])
    
    
    var apiKey: String {return  "3-E3kT-4fhk-VRgVA"}
    var baseURL: URL {return URL(string: "https://brickset.com/api/v3.asmx")!}
    
    var method: HTTPMethod {
        return .get
//        switch self {
//        case .get: return .get
//        case .post: return .post
//        }
    }
    
    var path: String {
        switch self {
        case .login: return "login"
        case .search : return "getSets"
//        case .post: return "post"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        switch self {
        case let .login(parameters):
            var params = parameters
            request = try URLEncodedFormParameterEncoder().encode(params, into: request)
        case let .search(parameters):
            var params = parameters
            params["apiKey"] = apiKey
//            request = try URLEncodedFormParameterEncoder().encode(params, into: request)
//            
//        case let .search(parameters):
//            var params = parameters
//            params["apiKey"] = apiKey
//            request = try JSONParameterEncoder().encode(parameters, into: request)
        }
        return request
    }
}

//struct APIParams : Encodable {
//
//}
