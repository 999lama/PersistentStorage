//
//  CoreDanaManager.swift
//  NotyApp
//
//  Created by Lama Albadri on 20/02/2023.
//

import CoreData

protocol coreDataStack: AnyObject {
    var modelName: String {get} /*what ever the .xcdatamodel name */
    var managedObjectContext: NSManagedObjectContext {get}
    var managedObjectModel: NSManagedObjectModel {get}
    var persistentStoreCoordinator: NSPersistentStoreCoordinator {get}
}

final class CoreDataManager: coreDataStack {
    
    // MARK: - Properties
    private(set) var modelName: String
    
   
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        // Initialize Managed Object Context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    
    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        // Fetch Model URL
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
        
        // Initialize Managed Object Model
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        
        return managedObjectModel
    }()
    
    private(set) lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // Initialize Persistent Store Coordinator
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        // Helpers
        let fileManager = FileManager.default
        let storeName = "\(self.modelName).sqlite"
        
        // URL Documents Directory
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        // URL Persistent Store
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
        
        do {
            // Add Persistent Store
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL, options: nil)
            
        } catch {
            fatalError("Unable to Add Persistent Store")
        }
        
        return persistentStoreCoordinator
    }()
    
    
    
}
