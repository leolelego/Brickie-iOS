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
    

}


