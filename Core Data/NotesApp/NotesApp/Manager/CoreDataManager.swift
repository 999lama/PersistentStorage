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
        ///.mainQueueConcurrencyType -> that's means managedObjectContext is associated with the mainQueue of the app
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    } ()
    
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        // [1] ask the app bundle for url of the Data Model
        // momd extension
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else { ///momd this is the comact version of data model
            fatalError("Unable to find data Model")
        }
        
        // [2] we use the url to instance the object of managedObject class
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to load data Model")
        }
        
        return managedObjectModel
    } ()
    
    private(set) lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // [1] first persistentStoreCoordinator instance
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        // [2] the core data funcational only if the persistentStore add to persistentStoreCoordimnator
        let fileManager = FileManager.default
        /// .sqlite because we will use a sqlite type of the persistentStoreCoordinator
        let storeName = "\(self.modelName).sqlite"
        /// to save the persistentStoreCoordinator in the documentDirectory - we can store it in another places like libary directory
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(type: .sqlite,    configuration: nil, at: persistentStoreURL, options: nil)
            
        } catch {
            fatalError("Unable to Add Persistent Store")
        }
        
        return persistentStoreCoordinator
        
    } ()
    
    
    func saveContext() {
        guard managedObjectContext.hasChanges else {return}
        do {
            try managedObjectContext.save()
        } catch {
            print("error to save \(error.localizedDescription)")
        }
    }
}
