//
//  Note.swift
//  Notes
//
//  Created by Bart Jacobs on 06/07/2017.
//  Copyright © 2017 Cocoacasts. All rights reserved.
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
