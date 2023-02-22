//
//  ManagedContext+Extension.swift
//  NotyApp
//
//  Created by Lama Albadri on 21/02/2023.
//

import Foundation
import CoreData



extension NSManagedObjectContext {
    
    
    func saveHandler() {
        do {
            try CoreDataManager.shared.managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
