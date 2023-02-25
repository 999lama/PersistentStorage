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
    
    /// [1] create  fetchResultController
    private lazy var fetchResultController: NSFetchedResultsController<Note> = {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        /// [2] add sortDescriptors to  fetchResultController
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Note.updatedAt), ascending: false)]
        /// [3] we add the context that note associate with
        let fetechResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.shared.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        /// [4] confirm it to the delegate
        fetechResultController.delegate = self
        return fetechResultController
    }()
    
    
    
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
        do {
            try fetchResultController.performFetch()
        } catch {
            print("Unable to peform fetch request")
            print(error.localizedDescription)
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
        // fetch the number of rows using fetchResultController
        guard let section = fetchResultController.sections?[section] else {
            return 0
        }
        return section.numberOfObjects
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // fetch the number of section using fetchResultController
        guard let section = fetchResultController.sections else {return 0}
        return section.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.identifier, for: indexPath) as! NoteCell
        self.configure(cell, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func configure(_ cell: NoteCell, at indexPath: IndexPath) {
        // fetch the note object using fetchResultController at indexPath
        let note = fetchResultController.object(at: indexPath)
        cell.titlelabel.text = note.title ?? ""
        cell.dateLabel.text = .convertDateToStr(date: note.updatedAt)
        cell.categoryView.backgroundColor = UIColor.getColorForCategory(index: indexPath.row)
        
    }
}

extension NotesListViewController: AddNoteDelegate {
    
    func didAddNote() {
        self.fetchchNotes()
    }
    
    
    
}


//// all the funcs for NSFetchedResultsControllerDelegate is optional
extension NotesListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // we start the batch for table view
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // we end the batch update for table view
        tableView.endUpdates()
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
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) as? NoteCell {
                self.configure(cell, at: indexPath)
            }
        case .move:
            /*When a managed object is modified, it can impact the sort order of the managed objects. This isn't easy to implement from scratch. Fortunately, the fetched results controller takes care of this as well through the move type.*/
            // in case of move we will delete the excusting indexPath, and we will insert in the newIndexpath
            //indexPath parameter represents the original position of the managed object
            //newIndexPath parameter represents the new position of the managed object.
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        @unknown default:
            fatalError("unkown action")
        }
    }
    
}

