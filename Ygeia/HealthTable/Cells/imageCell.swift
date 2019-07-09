//
//  imageCell.swift
//  Ygeia
//
//  Created by mohamed hisham on 6/9/19.
//  Copyright © 2019 hisham. All rights reserved.
//

import UIKit

class imageCell: UITableViewCell {

    @IBOutlet weak var cell: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       cell.layer.cornerRadius=7
        profileImage.layer.cornerRadius=20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
