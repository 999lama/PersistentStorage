//
//  LocalStoragManager.swift
//  StoreCustomeType
//
//  Created by Lama Albadri on 16/02/2023.
//

import Foundation

enum LocalStorageKeys: String, LocalStorageKeysProtocol {
    case note
}

class LocalStorage: LocalStorageProtocol {
    
    fileprivate let userDefaults: UserDefaults = UserDefaults.standard
    
    
    
    
    func value<T>(key: LocalStorageKeysProtocol) -> T? {
        return self.userDefaults.object(forKey: key.rawValue) as? T
    }
    
    func write<T>(key: LocalStorageKeysProtocol, value: T?) {
        self.userDefaults.synchronize()
        self.userDefaults.set(value, forKey: key.rawValue)
    }
    
    func remove(key: LocalStorageKeysProtocol) {
        self.userDefaults.synchronize()
        self.userDefaults.set(nil, forKey: key.rawValue)
    }
    
    func valueStoreable<T>(key: LocalStorageKeysProtocol) -> T? where T: Storeable {
         let data: Data? = self.userDefaults.data(forKey: key.rawValue)
         return T(storeData: data)
     }
     
     func writeStoreable<T>(key: LocalStorageKeysProtocol, value: T?) where T: Storeable {
         self.userDefaults.synchronize()
         self.userDefaults.set(value?.storeData, forKey: key.rawValue)
     }
    
}
