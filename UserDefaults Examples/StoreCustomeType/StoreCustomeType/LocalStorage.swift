//
//  LocalStorage.swift
//  StoreCustomeType
//
//  Created by Lama Albadri on 16/02/2023.
//

import Foundation

protocol LocalStorageKeysProtocol {
    var rawValue: String { get }
}

protocol Storeable {
    var storeData: Data? { get }
    init?(storeData: Data?)
}

protocol LocalStorageProtocol {
    func value<T>(key: LocalStorageKeysProtocol) -> T?
    func write<T>(key: LocalStorageKeysProtocol, value: T?)
    func remove(key: LocalStorageKeysProtocol)
    
    func valueStoreable<T>(key: LocalStorageKeysProtocol) -> T? where T: Storeable
    func writeStoreable<T>(key: LocalStorageKeysProtocol, value: T?) where T: Storeable
}

