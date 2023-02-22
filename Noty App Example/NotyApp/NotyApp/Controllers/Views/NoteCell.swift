//
//  NoteCell.swift
//  NotyApp
//
//  Created by Lama Albadri on 22/02/2023.
//

import UIKit

class NoteCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = String(describing: NoteCell.self)
    
    //MARK: - Properties
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryView: UIView!
    
    
    //MARK: - Life cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    
}
