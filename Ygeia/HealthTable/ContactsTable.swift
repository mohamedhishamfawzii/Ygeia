//
//  ContactsTable.swift
//  Ygeia
//
//  Created by mohamed hisham on 6/12/19.
//  Copyright © 2019 hisham. All rights reserved.
//

import UIKit

protocol EditContactslDelegate :AnyObject{
    func contactRemoved(index:Int)
}
class ContactsTable: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var reuseId = "TableViewCell"
    var homeNib = UINib(nibName: "TableViewCell", bundle: nil)
    var contacts :[String]=[]
      weak var delegate: EditContactslDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
      
    tableView.register(homeNib, forCellReuseIdentifier:reuseId)
        // Do any additional setup after loading the view.
    }


}
extension ContactsTable : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCell = (tableView.dequeueReusableCell(withIdentifier: reuseId) as? TableViewCell)!
        currentCell.textLabel?.text=contacts[indexPath.row]
        return currentCell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
           contacts.remove(at: indexPath.row)
            tableView.reloadData()
            delegate?.contactRemoved(index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let url = URL(string: "tel://\(contacts[indexPath.row])")
        UIApplication.shared.open(url!)
    }
    
    
}

