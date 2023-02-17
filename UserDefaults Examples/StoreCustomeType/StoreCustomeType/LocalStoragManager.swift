//
//  LocalStoragManager.swift
//  StoreCustomeType
//
//  Created by Lama Albadri on 16/02/2023.
//

import Foundation

enum LocalStorageKeys: String, LocalStorageKeysProtocol {
    case reminder
    case simpleStr
}

class LocalStorage: LocalStorageProtocol {
    
    fileprivate let userDefaults: UserDefaults = UserDefaults.standard
    
    ///use to read simple object: Int - string - bool - double - flot ..etc
    func value<T>(key: LocalStorageKeysProtocol) -> T? {
        return self.userDefaults.object(forKey: key.rawValue) as? T
    }
    
    ///use to write simple object: Int - string - bool - double - flot ..etc
    func write<T>(key: LocalStorageKeysProtocol, value: T?) {
        self.userDefaults.set(value, forKey: key.rawValue)
    }
    ///use to remove object
    func remove(key: LocalStorageKeysProtocol) {
        self.userDefaults.set(nil, forKey: key.rawValue)
    }
    
    ///use to read complex object class or strcut
    func valueStoreable<T>(key: LocalStorageKeysProtocol) -> T? where T: Storeable {
         let data: Data? = self.userDefaults.data(forKey: key.rawValue)
         return T(storeData: data)
     }
    ///use to write complex object class or strcut
     func writeStoreable<T>(key: LocalStorageKeysProtocol, value: T?) where T: Storeable {
         self.userDefaults.set(value?.storeData, forKey: key.rawValue)
     }
    
}
