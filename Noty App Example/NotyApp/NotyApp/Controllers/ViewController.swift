//
//  ViewController.swift
//  NotyApp
//
//  Created by Lama Albadri on 20/02/2023.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    private var coreDataManager = CoreDataManager(modelName: .modelName)
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        print(coreDataManager.managedObjectContext)
    }


}

