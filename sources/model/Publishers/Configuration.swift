//
//  Configuration.swift
//  BrickSet
//
//  Created by Work on 01/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import Foundation
import Reachability
import Combine

extension  Reachability.Connection{
    var cantUpdateDB : Bool {
        return  self == .unavailable || (ProcessInfo.processInfo.isLowPowerModeEnabled == true && self == .cellular)
    }
}
class Configuration : ObservableObject {
   
    private var reachability: Reachability = try! Reachability()
    
    @Published var connection: Reachability.Connection = .wifi {
        willSet {
                   objectWillChange.send()
               }
    }
    

    
    init() {
        
        connection = reachability.connection
             reachability.whenReachable = { [weak self] reachability in
                 guard let self = self else { return }
                 self.connection = reachability.connection
             }
             
             reachability.whenUnreachable = { [weak self] unreachable in
                 guard let self = self else { return }
                 self.connection = unreachable.connection
                 
             }
        do {
     
            try reachability.startNotifier()
        } catch {
            logerror(error)
        }
    }
//    
//    @Published var uiMinifigVisible: Bool = true
//    @Published var uiSetThumbail = true
//    
    static let isDebug: Bool = {
        var info = kinfo_proc()
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout.stride(ofValue: info)
        let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
        assert(junk == 0, "sysctl failed")
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }()
    
//    enum Link {
//        case signup =
//        case brickset =
//        case homework =
//        case me = "https://twitter.com/leolelego"
//
//    }
    
    
}


struct User {
    let username : String
    let token : String
}
