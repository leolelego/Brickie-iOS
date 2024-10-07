//
//  Locale+Ext.swift
//  Brickie
//
//  Created by Léo on 05/04/2023.
//  Copyright © 2023 Homework. All rights reserved.
//

import Foundation

extension Locale {
    static var currentRegionCode : String {
        return Locale.current.region?.identifier ?? "us"
    }
}
