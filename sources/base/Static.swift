//
//  Static.swift
//  Brickie
//
//  Created by Léo on 29/07/2021.
//  Copyright © 2021 Homework. All rights reserved.
//

import Foundation
let kAppversion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
let kAppBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
let kFeedbackMailto = "mailto:brickieapp@icloud.com?subject=Brickie App Feedback v\(kAppversion) (\(kAppBuild))".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
let thisYear : Int = {
    let date = Date()
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year], from: date)
    let year = components.year
    return year ?? 2025
}()
