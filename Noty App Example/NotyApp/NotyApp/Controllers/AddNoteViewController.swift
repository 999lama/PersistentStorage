//
//  AddNoteViewController.swift
//  NotyApp
//
//  Created by Lama Albadri on 22/02/2023.
//

import UIKit

protocol AddNoteDelegate: AnyObject {
    func didAddNote()
}

class AddNoteViewController: UIViewController {
    
    
    lazy var delegate: AddNoteDelegate? = nil
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var colorButton: UIButton! {
        didSet {
            self.colorButton.layer.cornerRadius = 15
            self.colorButton.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var addNoteBtn: UIButton! {
        didSet{
            self.addNoteBtn.layer.cornerRadius = 15
            self.addNoteBtn.layer.masksToBounds = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add Note"
        self.navigationItem.largeTitleDisplayMode = .never
        self.hideKeyboardWhenTappedAround()
        

    }
    
    
    @IBAction func didClickAdd(_ sender: UIButton) {
        self.saveNoteHandler()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapPickColor(_ sender: UIButton) {
        //TO DO: show color picker view
        self.present(self.createPickerView(), animated: true, completion: nil)
    }
    
    private func createPickerView() -> UIColorPickerViewController {
        // Initializing Color Picker
        let picker = UIColorPickerViewController()
        // Setting the Initial Color of the Picker
        picker.selectedColor = self.colorButton.backgroundColor ?? .white
        // Setting Delegate
        picker.delegate = self
        picker.modalPresentationStyle = .popover
        return picker
    }
    
    
    private func saveNoteHandler() {
        guard let title = self.titleTF.text, !title.isEmpty else {
            showAlert(with: "Title Missing", and: "Your note doesn't have a title.")
            return
        }
        
        let note = Note(context: CoreDataManager.shared.managedObjectContext)
        note.title = title
        note.body = self.bodyTextView.text
        note.updatedAt = Date()
        note.createdAt = Date()
        
        CoreDataManager.shared.managedObjectContext.saveHandler()
        delegate?.didAddNote()
    }
    

}

extension AddNoteViewController: UIColorPickerViewControllerDelegate {
    
    //  Called once you have finished picking the color.
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.colorButton.backgroundColor  = viewController.selectedColor
        
    }
    
    //  Called on every color selection done in the picker.
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        self.colorButton.backgroundColor = viewController.selectedColor
    }
}

