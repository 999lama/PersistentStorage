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
    
    var alphabetizedTags: [Tag]? {
        guard let tags = tags as? Set<Tag> else {
            return nil
        }
        return tags.sorted(by: {
            guard let tag0 = $0.name else {return true}
            guard let tag1 = $1.name else {return true}
           
            return tag0 < tag1
        })
    }

    var alphabetizedTagsString: String? {
        guard let tags = alphabetizedTags, tags.count > 0 else {
            return nil
        }
        // we used flatMap to remove any tag that haven't name
        let names = tags.flatMap{ $0.name }
        return names.joined(separator: ", ")
    }
}
