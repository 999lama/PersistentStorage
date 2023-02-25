//
//  ViewController.swift
//  NotyApp
//
//  Created by Lama Albadri on 20/02/2023.
//

import UIKit
import CoreData

class NotesListViewController: UIViewController {
    
    //MARK: - Properties
    var notes: [Note]?
    
    //MARK: -  @IBOutlet
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.separatorStyle = .none
            self.tableView.register(UINib(nibName: NoteCell.identifier, bundle: nil), forCellReuseIdentifier: NoteCell.identifier)
        }
    }
    
    //MARK: - Life Cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()    
        self.fetchchNotes()
        UIDevice.printFolderPath()
        
        
        
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
    
    
    @IBAction func addDidTap(_ sender: UIButton) {
        print("add button tap")
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "addNote":
            guard let destination = segue.destination as? AddNoteViewController else {
                return
            }
            destination.delegate = self
            
        default:
            break
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

extension NotesListViewController: AddNoteDelegate {
    
    func didAddNote() {
        self.fetchchNotes()
    }
    
    
    
}
