//
//  UIDecive+Extension.swift
//  NotyApp
//
//  Created by Lama Albadri on 22/02/2023.
//

import UIKit


extension UIDevice {
    class func printFolderPath() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("✅ \(documentsPath)")
    }
}
