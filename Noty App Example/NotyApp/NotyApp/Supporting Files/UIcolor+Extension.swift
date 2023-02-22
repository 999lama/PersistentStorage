//
//  UIcolor+Extension.swift
//  NotyApp
//
//  Created by Lama Albadri on 22/02/2023.
//

import Foundation
import UIKit


extension UIColor {
    
    static let notyCategoryColors: [UIColor] = [.systemGreen, .systemBlue, .systemYellow, .systemPink, .systemPurple, .systemRed, .systemGray]
    
    static func getColorForCategory(index: Int) -> UIColor {
        return self.notyCategoryColors[index % self.notyCategoryColors.count]
    }
    
}
