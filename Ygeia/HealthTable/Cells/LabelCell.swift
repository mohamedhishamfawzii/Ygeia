//
//  LabelCell.swift
//  Ygeia
//
//  Created by mohamed hisham on 5/29/19.
//  Copyright © 2019 hisham. All rights reserved.
//

import UIKit

class LabelCell: UITableViewCell {

    
    
    @IBOutlet weak var value: UILabel?
    @IBOutlet weak var attribute: UILabel?


    @IBOutlet weak var cell: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cell.layer.cornerRadius=7
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
