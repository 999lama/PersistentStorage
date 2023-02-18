//
//  ViewController.swift
//  Notes
//
//  Created by Bart Jacobs on 05/07/2017.
//  Copyright © 2017 Cocoacasts. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {
    
    
    // MARK: - Segues
    private enum Segue {
        static let AddNote = "AddNote"
        static let Note = "Note"
        
    }
    
    // MARK: -  @IBOutlets
    @IBOutlet var notesView: UIView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Properties
    private var notes: [Note]? {
        didSet {
            updateView()
        }
    }
    
    private var hasNotes: Bool {
        guard let fetchObjects = fetchResultController.fetchedObjects else {return false}
        return fetchObjects.count > 0
    }
    
    private var coreDataManager = CoreDataManager(modelName: "Notes")
    private let estimatedRowHeight = CGFloat(44.0)
    
    
    /// [1] create  fetchResultController
    private lazy var fetchResultController: NSFetchedResultsController<Note> = {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        /// [2] add sortDescriptors to  fetchResultController
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Note.updatedAt), ascending: false)]
        /// [3] we add the context that note associate with
        let fetechResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.coreDataManager.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        /// [4] confirm it to the delegate
        fetechResultController.delegate = self
        return fetechResultController
    }()
    
    private lazy var updatedAtDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, HH:mm"
        return dateFormatter
    }()
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? "")
        setupView() // set the empty view first
        fetchNotes() // fetch the notes using fetchResultController
        updateView() // update the view to remove empty if we have a notes
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case Segue.Note:
            guard let destination = segue.destination as? NoteViewController else {
                return
            }
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            // fetch the object using fetchResultController at indexPath
            let note = fetchResultController.object(at: indexPath)
            destination.note = note
            
        case Segue.AddNote:
            guard let destination = segue.destination as? AddNoteViewController else {
                return
            }
        
            // Configure Destination
            destination.managedObjectContext = coreDataManager.managedObjectContext
        default:
            break
        }
    }
    
    // MARK: - View Methods
    
    private func setupView() {
        setupMessageLabel()
        setupTableView()
    }
    
    private func updateView() {
        tableView.isHidden = !hasNotes
        messageLabel.isHidden = hasNotes
    }
    
    private func fetchNotes() {
        do {
            try fetchResultController.performFetch()
        } catch {
            print("Unable to peform fetch request")
            print(error.localizedDescription)
        }
    }
    
    
    private func setupMessageLabel() {
        messageLabel.text = "You don't have any notes yet."
    }
    
    private func setupTableView() {
        tableView.isHidden = true
        tableView.estimatedRowHeight = estimatedRowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
}

extension NotesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // fetch the number of section using fetchResultController
        guard let section = fetchResultController.sections else {return 0}
        return section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // fetch the number of rows using fetchResultController
        guard let section = fetchResultController.sections?[section] else {
            return 0
        }
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue Reusable Cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as? NoteTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        self.configure(cell, at: indexPath)
        return cell
    }
    
    
    private func configure(_ cell: NoteTableViewCell, at indexPath: IndexPath) {
        // fetch the note object using fetchResultController at indexPath
        let note = fetchResultController.object(at: indexPath)
        cell.titleLabel.text = note.title
        cell.contentsLabel.text = note.contents
        cell.updatedAtLabel.text = updatedAtDateFormatter.string(from: note.updatedAtAsDate)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard  editingStyle == .delete else {return}
        // fetch the note object using fetchResultController at indexPath
        let note = fetchResultController.object(at: indexPath)
        coreDataManager.managedObjectContext.delete(note)
    }
    
    
}

//// all the funcs for NSFetchedResultsControllerDelegate is optional
extension NotesViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // we start the batch for table view
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // we end the batch update for table view
        tableView.endUpdates()
        updateView() // we call this func in case if empty result
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            // in case of insert we will insert to the last excusting indexPath
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        case .delete:
            // in case of delete we will delete to the last excusting indexPath
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            // in case of update we will update from the last excusting indexPath - upper first
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? NoteTableViewCell {
                self.configure(cell, at: indexPath)
            }
        case .move:
            // in case of move we will delete the excusting indexPath, and we will insert in the newIndexpath
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        }
    }
    
}

