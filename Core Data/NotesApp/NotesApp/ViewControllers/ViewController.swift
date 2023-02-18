//
//  ViewController.swift
//  NotesApp
//
//  Created by Lama Albadri on 09/02/2023.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    
    private let coreDataManager = CoreDataManager(modelName: "Notes")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let note = Note(context: coreDataManager.managedObjectContext)
        note.title = "My Second Note"
        note.createdAt = Date()
        note.updatedAt = Date()

        print(note.title ?? "No title")
        ///[1] access to entityDesc with  a context
        if let entityDesc = NSEntityDescription.entity(forEntityName: "Note", in: coreDataManager.managedObjectContext) {
            ///[2] create a NSManagedObject for an entity + insert in managedObjectContext
            let note = NSManagedObject(entity: entityDesc, insertInto: coreDataManager.managedObjectContext)
            ///[3] set the values for NSManagedObject
            note.setValue("My First Note", forKey: "title")
            note.setValue(Date(), forKey: "createdAt")
            note.setValue(Date(), forKey: "updatedAt")
            ///[4] save the NSManagedObject to managedObjectContext - the save can throw an error
            
            do {
                try coreDataManager.managedObjectContext.save()
            } catch {
                print("Unable to save managed object Context")
                print("\(error), \(error.localizedDescription)")
            }
            
            if let title = note.value(forKey: "title") as? String {
                print(title)
            }
            
            print(note)
        }
        
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last)
            
    }

    
    
    @IBAction func buttonClicked(_ sender: Any) {
    }
    
    
    private func createNote() {
        
        let note = Note(context: coreDataManager.managedObjectContext)
        note.title = "My Second Note"
        note.createdAt = Date()
        note.updatedAt = Date()
        
        coreDataManager
    }
    
}

