//
//  Logger.swift
//  Develop
//
//  Created by Work on 12/02/2019.
//  Copyright © 2019 WISIMAGE. All rights reserved.
//

import UIKit
import os.log

import os.log

let subsystem = Bundle.main.bundleIdentifier!

public func logerror(_ err:Error?,category:OSLogType.Category = .app){
    log(err?.localizedDescription ?? "Unknow Error",category:category,.error)
}
public func log(_ message:String,category:OSLogType.Category = .app,_ type : OSLogType = .debug){
    os_log("%{PUBLIC}@:%{PUBLIC}@", log: OSLog(subsystem: subsystem, category: category.rawValue), type: type,type.emoji,message)
}


extension OSLogType {
        var emoji : String {
            switch self {
            case .error:
                return "🚷"
            case .fault:
                return "🚸"
            case .info:
                return "✅"
            default:
                return "👾"
            }
        }
    public enum Category:String {
        case app = "app"
        case lifeCycle = "viewLifeCycle"
        case network = "network"
        case api = "api"
    }
}

