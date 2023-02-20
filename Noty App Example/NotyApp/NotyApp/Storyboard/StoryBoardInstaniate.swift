//
//  StoryBoardInstaniate.swift
//  NotyApp
//
//  Created by Lama Albadri on 21/02/2023.
//

import UIKit


protocol StoryBorded {
    static var storBoardName: String {get}
    static func instaniate() -> UIViewController
}

extension StoryBorded where Self: UIViewController {
    
    static var storBoardName: String {
        "Main"
    }
    
    static func instaniate() -> UIViewController {
        let storyBoard = UIStoryboard(name: storBoardName, bundle: .main)
        return storyBoard.instantiateViewController(withIdentifier: String(describing: Self.self))
    }
    
}
