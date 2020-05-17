//
//  Configuration.swift
//  BrickSet
//
//  Created by Work on 01/05/2020.
//  Copyright © 2020 LEOLELEGO. All rights reserved.
//

import Foundation
import KeychainSwift

class Configuration : ObservableObject {
   
//    
//    @Published var uiMinifigVisible: Bool = true
//    @Published var uiSetThumbail = true
//    
    let isDebug: Bool = {
        var info = kinfo_proc()
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout.stride(ofValue: info)
        let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
        assert(junk == 0, "sysctl failed")
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }()
}


struct User {
    let username : String
    let token : String
}
