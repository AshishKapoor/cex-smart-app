//
//  CXTradeCurrencyVC.swift
//  CEX - My Smart Price Tracker
//
//  Created by Ashish Kapoor on 23/06/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import UIKit

class CXTradeCurrencyVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title                   = "Trade History"
        view.backgroundColor            = UIColor.black

        setupTableView()
        
        loadData()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor       = UIColor.black
        tableView.separatorStyle        = UITableViewCellSeparatorStyle.none
        tableView.rowHeight             = UITableViewAutomaticDimension
        tableView.estimatedRowHeight    = 44.0
        tableView.tableFooterView       = UIView()
        
        if #available(iOS 10.0, *) {
            refreshControl.tintColor = UIColor.white
            tableView.refreshControl = refreshControl
        } else {
            refreshControl.tintColor = UIColor.white
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(CXTradeCurrencyVC.refreshData(sender:)), for: .valueChanged)
        let attributes = [ NSForegroundColorAttributeName : UIColor.white ] as [String: Any]
        refreshControl.attributedTitle = NSAttributedString(string: "Updating ...", attributes: attributes)
    }
    
    func refreshData(sender: UIRefreshControl) -> Void {
        print("Haan bhenchod")
    }
    
    
    func loadData () {
        let url:URL = URL(string: tradeHistoryURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
//        let postString = "lastHours=7&maxRespArrSize=100"
//        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                for value in json as! JSONArray {
                    for (_, val) in value as! JSONDictionary {
                        print(val)
                    }
                }
                
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print("should ideally throw an error")
            }
        }
        task.resume()
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.backgroundColor            = UIColor.black
        cell.textLabel?.text            = "BTC"
        cell.textLabel?.textColor       = UIColor.appGreen()
        
        
        cell.detailTextLabel?.textColor = UIColor.appGreen()
        cell.detailTextLabel?.text      = "$5000"
        
        return cell
    }
    
}
