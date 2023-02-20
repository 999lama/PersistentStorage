//
//  UIDevice.swift
//  Notes
//
//  Created by Lama Albadri on 20/02/2023.
//  Copyright © 2023 Cocoacasts. All rights reserved.
//

import Foundation
import UIKit
extension UIDevice {
    class func printFolderPath() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        NSLog("✅ \(documentsPath)")
    }
}
