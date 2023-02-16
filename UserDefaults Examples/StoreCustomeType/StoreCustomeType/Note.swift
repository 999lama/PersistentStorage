//
//  Note.swift
//  StoreCustomeType
//
//  Created by Lama Albadri on 16/02/2023.
//

import Foundation

struct Note: Codable, Storeable {
    
    let id: Int
    let title: String
    let body: String
    
    var storeData: Data? {
        let encoder = JSONEncoder()
        let encoded = try? encoder.encode(self)
        return encoded
    }
    
    init(id: Int, title: String, body: String) {
        self.id = id
        self.title = title
        self.body = body
    }
    
    init?(storeData: Data?) {
        guard let storeData = storeData else { return nil}
        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode(Note.self, from: storeData) else { return nil }
        self = decoded
     
    }
}
