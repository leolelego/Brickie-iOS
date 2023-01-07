//
//  APIHelpers.swift
//  BrickSet
//
//  Created by Work on 01/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import Foundation
import SwiftUI
enum APIError : Error {
    case unknown
    case malformed
    case invalid
    case badData
    case invalidUserHash // Log out - Change password
    case apiLimitExceeded

    var localizedDescription: LocalizedStringKey {
        switch self {
        case .badData,.invalidUserHash:
            return "error.badlogin"
        case .invalid:
            return "error.noapiresponse"
        case .apiLimitExceeded:
            return "error.apilimitexceeded"
        default:
            return "error.unknown"
        }
    }
}

// MARK: - CharacterSet

extension CharacterSet {
    static var plus: CharacterSet {
        CharacterSet(charactersIn: "/+").inverted
    }
}
