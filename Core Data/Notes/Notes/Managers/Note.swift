//
//  Note.swift
//  Notes
//
//  Created by Lama Albadri on 18/02/2023.
//  Copyright © 2023 Cocoacasts. All rights reserved.
//

import Foundation

extension Note {
    var updatedAtAsDate: Date {
        return updatedAt ?? Date()
    }
    
    var createdAtAsDate: Date {
        return createdAt ?? Date()
    }
    
    
}
