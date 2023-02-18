//
//  NoteViewController.swift
//  Notes
//
//  Created by Lama Albadri on 18/02/2023.
//  Copyright © 2023 Cocoacasts. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {
    
    // MARK: - @IBOutles
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentsTextView: UITextView!
    
    // MARK: -  Properties
    
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Note"
        setupView()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        guard let note = note else { return }

        // Update Title
        if let title = titleTextField.text, !title.isEmpty && note.title != title {
            note.title = title
        }

        // Update Contents
        if note.contents != contentsTextView.text {
            note.contents = contentsTextView.text
        }

        // Update Updated At
        if note.isUpdated {
            /// we only want to update the updateAt if the note has been updated . isUpdated property is a prooprty of NSManagedObject * that's tells if the managed class has been updated *
            note.updatedAt = Date()
        }
        
    }
    
    private func setupView() {
        setupTitleTextField()
        setupContentsTextView()
    }
    
    private func setupTitleTextField() {
        // Configure Title Text Field
        titleTextField.text = note?.title
    }
    
    private func setupContentsTextView() {
        // Configure Contents Text View
        contentsTextView.text = note?.contents
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    
}
