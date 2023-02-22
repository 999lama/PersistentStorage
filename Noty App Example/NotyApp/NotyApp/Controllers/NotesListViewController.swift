//
//  ViewController.swift
//  NotyApp
//
//  Created by Lama Albadri on 20/02/2023.
//

import UIKit
import CoreData

class NotesListViewController: UIViewController {
    
    var notes: [Note]?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.separatorStyle = .none
            self.tableView.register(UINib(nibName: NoteCell.identifier, bundle: nil), forCellReuseIdentifier: NoteCell.identifier)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchchNotes()
        UIDevice.printFolderPath()
        let note = Note(context: CoreDataManager.shared.managedObjectContext)
        note.title = "My first Note"
        note.updatedAt = Date()
        note.createdAt = Date()
        note.body = ""
        
        CoreDataManager.shared.managedObjectContext.saveHandler()
        
        
        
    }
    
    
    private func fetchchNotes() {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Note.updatedAt), ascending: false)]
        
        // Perform Fetch Request
        CoreDataManager.shared.managedObjectContext.performAndWait {
            do {
                // Execute Fetch Request
                let notes = try fetchRequest.execute()
                
                // Update Notes
                self.notes = notes
                
                // Reload Table View
                self.tableView.reloadData()
                
            } catch {
                let fetchError = error as NSError
                print("Unable to Execute Fetch Request")
                print("\(fetchError), \(fetchError.localizedDescription)")
            }
        }
        
    }
    
    
}

extension NotesListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.identifier, for: indexPath) as! NoteCell
        let note = notes?[indexPath.row]
        cell.titlelabel.text = note?.title ?? ""
        
        cell.dateLabel.text = .convertDateToStr(date: note?.updatedAt)
        cell.categoryView.backgroundColor = UIColor.getColorForCategory(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
