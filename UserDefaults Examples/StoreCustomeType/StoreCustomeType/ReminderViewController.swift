//
//  ViewController.swift
//  StoreCustomeType
//
//  Created by Lama Albadri on 16/02/2023.
//

import UIKit


class ReminderViewController: UIViewController {
    
    let storage: LocalStorageProtocol = LocalStorage()
    
    @IBOutlet weak var noteTitle: UILabel!
    @IBOutlet weak var noteBody: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    
    private func configureUI() {
        if let reminder: Reminder = storage.valueStoreable(key: LocalStorageKeys.reminder) {
            guard !reminder.title.isEmpty, !reminder.body.isEmpty else {
                self.noteTitle.text = ""
                self.noteBody.text = ""
                return
            }
            self.noteTitle.text = "Last reminder title is \n \(reminder.title)"
            self.noteBody.text = "Last reminder body is \n \(reminder.body)"
            self.view.layoutIfNeeded()
        }
    }
    
    
    func saveReminderHandler(reminder: Reminder) {
        storage.writeStoreable(key: LocalStorageKeys.reminder, value: reminder)
    }
    
    
    
    @IBAction func addClicked(_ sender: Any) {
        let vc = CustomModalViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        if let reminder: Reminder = storage.valueStoreable(key: LocalStorageKeys.reminder) {
            print(reminder)
        }
        self.present(vc, animated: false)
    }
}

extension ReminderViewController: ReminderHandler {
    func saveReminder(with title: String, and body: String) {
        self.saveReminderHandler(reminder: Reminder(id: 1, title: title, body: body))
        self.configureUI()
    }
    
    
}
