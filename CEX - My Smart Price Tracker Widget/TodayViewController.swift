//
//  TodayViewController.swift
//  CEX - My Smart Price Tracker Widget
//
//  Created by Ashish Kapoor on 29/06/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import UIKit
import NotificationCenter

let appGroup:String = "group.cex-my-smart-price-tracker.app"

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var data:[String] = [""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
        }
        else {
            self.preferredContentSize = CGSize(width: 0, height: 280)
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        guard let loadedNotes:[String] = UserDefaults(suiteName:appGroup)!.array(forKey: "notes") as? [String] else {
            completionHandler(.failed)
            return
        }
        
        if data.first != loadedNotes.first {
            data = loadedNotes
            tableView.reloadData()
            completionHandler(.newData)
            return
        }
        
        completionHandler(.noData)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
}
