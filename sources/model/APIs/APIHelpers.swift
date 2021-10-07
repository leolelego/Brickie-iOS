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

    var localizedDescription: LocalizedStringKey {
        switch self {
        case .badData,.invalidUserHash:
            return "error.badlogin"
        case .invalid:
            return "error.noapiresponse"
        default:
            return "error.unknown"
        }
    }
}
