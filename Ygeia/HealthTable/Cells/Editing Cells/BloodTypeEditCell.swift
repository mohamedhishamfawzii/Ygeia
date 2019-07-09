//
//  BloodTypeEditCell.swift
//  Ygeia
//
//  Created by mohamed hisham on 6/8/19.
//  Copyright © 2019 hisham. All rights reserved.
//

import UIKit

class BloodTypeEditCell: UITableViewCell {
   
    @IBOutlet weak var cell: UIView!
    
    @IBOutlet weak var picker: UIPickerView!

    override func awakeFromNib() {
        super.awakeFromNib()
      
       
        cell.layer.cornerRadius=7
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
