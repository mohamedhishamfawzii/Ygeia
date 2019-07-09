//
//  TodayViewController.swift
//  Ygeia Widget
//
//  Created by mohamed hisham on 6/9/19.
//  Copyright © 2019 hisham. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var blood: UILabel!
    
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    var userDefaults=UserDefaults(suiteName: "group.Ygeia")
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = userDefaults?.object(forKey: "image")
        {
            userImage.image = UIImage(data: data as! Data)!
            print("loading image success")
            
        }
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        let decoder = JSONDecoder()
        if let userD = userDefaults!.data(forKey: "user"),
            let userr = try? decoder.decode(User.self, from: userD) {
            
            name.text=userr.name
            height.text=userr.height
            blood.text=userr.bloodType
        }
        
        
        // Do any additional setup after loading the view.
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: 200) : maxSize
    }
}
