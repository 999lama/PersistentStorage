//
//  ViewController.swift
//  StoreCustomeType
//
//  Created by Lama Albadri on 16/02/2023.
//

import UIKit


let storage: LocalStorageProtocol = LocalStorage()

class NoteListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    
    func createANote(note: Note) {
        
        storage.writeStoreable(key: LocalStorageKeys.note, value: note)
        let note1: Note? = storage.valueStoreable(key: LocalStorageKeys.note)
        print(note1 ?? "")
        
    }
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    @IBAction func addClicked(_ sender: Any) {
        let vc = CustomModalViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        if let note: Note = storage.valueStoreable(key: LocalStorageKeys.note) {
            print(note)
        }
        self.present(vc, animated: false)
    }
}

extension NoteListViewController: NoteHandler {
    func createNote(with title: String, and body: String) {
        self.createANote(note: Note(id: 1, title: title, body: body))
    }
    
    
    
}
