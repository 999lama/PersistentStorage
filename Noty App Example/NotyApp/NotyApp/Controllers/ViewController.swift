//
//  ViewController.swift
//  NotyApp
//
//  Created by Lama Albadri on 20/02/2023.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        print(CoreDataManager.shared.managedObjectContext)
    }


}

