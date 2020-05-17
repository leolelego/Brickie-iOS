//
//  APIHelpers.swift
//  BrickSet
//
//  Created by Work on 01/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import Foundation

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
