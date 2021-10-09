//
//  CurrencyPickerview.swift
//  Brickie
//
//  Created by Léo on 09/10/2021.
//  Copyright © 2021 Homework. All rights reserved.
//

import SwiftUI


//
//enum Currency : String ,CaseIterable{
//    case `default` = "eu"
//    case us
//    case ca
//    case gb
//    
//    var text : String {
//        switch self {
//        case .default: return "currency.euro"
//        case .us: return "currency.usDollars"
//        case .ca: return "currency.caDollars"
//        case .gb: return "currency.livre"
//        }
//    }
//    
//    func format(price:Float) -> String?{
//        
//        let f = NumberFormatter()
//        f.numberStyle = .currency
//        
//        
//        switch self {
//        case .ca:
//            f.currencyCode = "CAD"
//        case .us:
//            f.currencyCode = "USD"
//            break
//        case .gb:
//            f.currencyCode = "GBP"
//            break
//        default:
//            f.currencyCode = "EUR"
//        }
//        return f.string(for:price)
//        
//    }
//}
