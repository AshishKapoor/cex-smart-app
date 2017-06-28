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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title                   = "Trade History"
        
        tableView.dataSource    = self
        tableView.delegate      = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.tableFooterView = UIView()
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData () {
        let url:URL = URL(string: currencyLimitsURL)!
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
                guard let responseArray = json as? JSONArray else {return}
                for responsePriceStats in responseArray {
                    print(responsePriceStats)
                    guard let safePriceStats = responsePriceStats as? JSONDictionary else {return}
                    print(safePriceStats)
                    
                    self.tableView.reloadData()
                }
            } catch {
                print("should ideally throw an error")
            }
        }
        task.resume()
    }

    // MARK: - Table view data source
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        cell.textLabel?.text = "BTC"
        cell.detailTextLabel?.text = "$5000"
        
        return cell
    }
    
}
