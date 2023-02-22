//
//  Constant.swift
//  NotyApp
//
//  Created by Lama Albadri on 20/02/2023.
//

import Foundation

extension String {
    
    static let modelName = "Noty"
    
    
    static func convertDateToStr(date: Date?) -> Self {
        let date = date ?? Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/YYYY"
        return dateFormatter.string(from: date )
    }
}
