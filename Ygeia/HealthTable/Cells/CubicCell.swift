//
//  CubicCell.swift
//  Ygeia
//
//  Created by mohamed hisham on 6/3/19.
//  Copyright © 2019 hisham. All rights reserved.
//

import UIKit

class CubicCell: UITableViewCell {

    @IBOutlet weak var gradView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        gradView.layer.cornerRadius=3
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
