//
//  NoteViewController.swift
//  Notes
//
//  Created by Bart Jacobs on 06/07/2017.
//  Copyright © 2017 Cocoacasts. All rights reserved.
//

import UIKit
import CoreData

class NoteViewController: UIViewController {

    // MARK: - Segues

    private enum Segue {

        static let Categories = "Categories"

    }

    // MARK: - Properties

    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var contentsTextView: UITextView!

    // MARK: -

    var note: Note?
    
    // MARK: - View Life Cycle

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
            note.updatedAt = Date()
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }

        switch identifier {
        case Segue.Categories:
            guard let destination = segue.destination as? CategoriesViewController else {
                return
            }

            // Configure Destination
            destination.managedObjectContext = note?.managedObjectContext
        default:
            break
        }
    }

    // MARK: - View Methods

    private func setupView() {
        setupCategoryLabel()
        setupTitleTextField()
        setupContentsTextView()
    }

    // MARK: -

    private func setupTitleTextField() {
        // Configure Title Text Field
        titleTextField.text = note?.title
    }

    private func setupContentsTextView() {
        // Configure Contents Text View
        contentsTextView.text = note?.contents
    }

    private func setupCategoryLabel() {
        updateCategoryLabel()
    }

    private func updateCategoryLabel() {

    }

}
