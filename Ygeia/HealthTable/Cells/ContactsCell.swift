//
//  ContactsCell.swift
//  Ygeia
//
//  Created by mohamed hisham on 6/12/19.
//  Copyright © 2019 hisham. All rights reserved.
//

import UIKit
protocol EditContactslCellDelegate :AnyObject{
    func contactRemovedCell(index:Int)
    func expandCollpase(expanded:Bool)
}
class ContactsCell: UITableViewCell {
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var expandCollapse: UIButton!
    var contacts:[String]=[]
    var expanded = false
    var reuseId = "cellCell"
    var homeNib = UINib(nibName: "cellCell", bundle: nil)
     weak var delegate: EditContactslCellDelegate?
    @IBOutlet weak var tableView: UITableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.register(homeNib, forCellReuseIdentifier: reuseId)
        // Initialization code
        print(tableView.delegate)
        tableView.delegate=self
        tableView.dataSource=self
        view.layer.cornerRadius=7
        tableView.isHidden=true  
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func expandCollapseAction(_ sender: Any) {
        if (expanded){
            expanded=false
            tableView.isHidden=true
            expandCollapse.setTitle("Expand", for: .normal)
            delegate?.expandCollpase(expanded: expanded)
        }else{
            expanded=true
              tableView.isHidden=false
            expandCollapse.setTitle("Collapse", for: .normal)
            delegate?.expandCollpase(expanded: expanded)
        }
        
        
    }
    
}
extension ContactsCell : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCell = (tableView.dequeueReusableCell(withIdentifier: reuseId) as? cellCell)!
        currentCell.textLabel?.text=contacts[indexPath.row]
        return currentCell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            contacts.remove(at: indexPath.row)
            tableView.reloadData()
            delegate?.contactRemovedCell(index: indexPath.row)
        }
    }
  
    
  
    
    
}
