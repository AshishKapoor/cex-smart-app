//
//  CXTradeCurrencyVC.swift
//  CEX - My Smart Price Tracker
//
//  Created by Ashish Kapoor on 23/06/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CXTradeCurrencyVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    var tradeHistory = [CXTradeHistory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title                           = "Trade History - ETH/USD"
        view.backgroundColor            = UIColor.black
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.refreshData(sender: refreshControl)
        setupAdMob()
    }
    
    func setupAdMob() {
//        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID]
        
        bannerView.adUnitID = "ca-app-pub-1816315233369355/9965504421"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor       = UIColor.black
        tableView.separatorStyle        = UITableViewCellSeparatorStyle.none
        tableView.rowHeight             = UITableViewAutomaticDimension
        tableView.estimatedRowHeight    = 50.0
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
        if tradeHistory.count > 0 {
            clearData()
        }
        loadData()
    }
    
    func clearData() {
        tradeHistory.removeAll()
        tableView.reloadData()
    }
    
    func loadData () {
        let url:URL = URL(string: tradeHistoryURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                for value in json as! JSONArray {
                    self.tradeHistory.append(CXTradeHistory(json: value as! JSONDictionary))
                }
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.refreshControl.endRefreshing()
                    }
                }
            } catch {}
        }
        task.resume()
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tradeHistory.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let data = self.tradeHistory[indexPath.row]
        
        cell.backgroundColor            = UIColor.black
        
        cell.textLabel?.text            = data.amount
        cell.textLabel?.textColor       = UIColor.appGreen()
        if #available(iOS 8.2, *) {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 30, weight: UIFontWeightBold)
        } else {
            // Fallback on earlier versions
            cell.textLabel?.font = UIFont.systemFont(ofSize: 30)
        }
        cell.detailTextLabel?.text      = ("\(data.type?.capitalized ?? "") at price: \(data.price ?? "")")
        if data.type?.capitalized == "Buy" {
            cell.detailTextLabel?.textColor = UIColor(colorLiteralRed: 0, green: 150, blue: 100, alpha: 0.6)
        } else {
            cell.detailTextLabel?.textColor = UIColor(colorLiteralRed: 150, green: 100, blue: 0, alpha: 0.6)
        }
        cell.detailTextLabel?.font      = UIFont.boldSystemFont(ofSize: 15)
        
        return cell
    }
    
}
