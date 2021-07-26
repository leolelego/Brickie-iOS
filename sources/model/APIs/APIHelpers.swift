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
    case badLogin
    case malformed
    case invalid

    var localizedDescription: LocalizedStringKey {
        switch self {
        case .badLogin:
            return "error.badlogin"
        case .invalid:
            return "error.noapiresponse"
        default:
            return "error.unknown"
        }
    }
}
