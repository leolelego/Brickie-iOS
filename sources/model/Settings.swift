////
////  Settings.swift
////  BrickSet
////
////  Created by Work on 06/05/2020.
////  Copyright © 2020 LEOLELEGO. All rights reserved.
////
//// 
//import Foundation
//import Combine
//
//class AppUserDefaults : ObservableObject {
//    
//    let objectWillChange = PassthroughSubject<Void, Never>()
//
//    @UserDefault("fam.hmwk.currency", defaultValue: Currency.US)
//    public static var currency: Currency {
//        willSet {
//            ObjectWillChangePublisher.send()
//        }
//    }
//    
//    @UserDefault("fam.hmwk.", defaultValue: false)
//    public static var showMinifigsSection: Bool
//}
//
//enum Currency : String {
//    case US
//    case CA
//    case DE
//}
//@propertyWrapper
//public struct UserDefault<T> {
//    let key: String
//    let defaultValue: T
//    
//    init(_ key: String, defaultValue: T) {
//        self.key = key
//        self.defaultValue = defaultValue
//    }
//    
//    public var wrappedValue: T {
//        get {
//            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: key)
//        }
//    }
//}
//@propertyWrapper
//public struct UserDefaultEnum<T: RawRepresentable> where T.RawValue == String {
//    let key: String
//    let defaultValue: T
//    
//    init(_ key: String, defaultValue: T) {
//        self.key = key
//        self.defaultValue = defaultValue
//    }
//    
//    public var wrappedValue: T {
//        get {
//            if let string = UserDefaults.standard.string(forKey: key) {
//                return T(rawValue: string) ?? defaultValue
//            }
//            return defaultValue
//        }
//        set {
//            UserDefaults.standard.set(newValue.rawValue, forKey: key)
//        }
//    }
//}
