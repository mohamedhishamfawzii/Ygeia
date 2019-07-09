//
//  editTextCell.swift
//  Ygeia
//
//  Created by mohamed hisham on 6/7/19.
//  Copyright © 2019 hisham. All rights reserved.
//

import UIKit

protocol EditCellDelegate :AnyObject{
    func editingDidEnd(cell: EditLabelCell)
}
class EditLabelCell: UITableViewCell {
   
    @IBOutlet weak var cell: UIView!
    
    @IBOutlet weak var value: UITextField!
    @IBOutlet weak var attribute: UILabel!
     weak var delegate: EditCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
         cell.layer.cornerRadius=7
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editingDidEnd(_ sender: Any) {
        delegate?.editingDidEnd(cell: self)
    }
    
    
}
