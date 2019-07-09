//
//  BigTextCell.swift
//  Ygeia
//
//  Created by mohamed hisham on 6/8/19.
//  Copyright © 2019 hisham. All rights reserved.
//

import UIKit

class BigTextCell: UITableViewCell {

    
    @IBOutlet weak var Attribute: UILabel!
    @IBOutlet weak var cell: UIView!
    @IBOutlet weak var textValue: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cell.layer.cornerRadius=4
        textValue.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        textValue.layer.borderWidth = 1.0
        textValue.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
