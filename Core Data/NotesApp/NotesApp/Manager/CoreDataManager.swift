//
//  CoreDataManager.swift
//  NotesApp
//
//  Created by Lama Albadri on 09/02/2023.
//

import CoreData

final class CoreDataManager { /// final we don't want this class for have sub-class
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        /// managedObjectContext os associated with the mainQueue of the app
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    } ()
    
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else { ///momd this is the comact version of data model
            fatalError("Unable to find data Model")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to load data Model")
        }
        
        return managedObjectModel
    } ()
    
    private(set) lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let fileManager = FileManager.default
        /// .sqlite because we will use a sqlite type of the persistentStoreCoordinator
        let storeName = "\(self.modelName).sqlite"
        /// to save the persistentStoreCoordinator in the documentDirectory
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        

        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(type: .sqlite,
                                                              configuration: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
            
        } catch {
            fatalError("Unable to Add Persistent Store")
        }
        
        return persistentStoreCoordinator
        
    } ()
}
