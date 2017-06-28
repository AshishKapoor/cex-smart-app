//
//  CXPriceCurrencyVC.swift
//  CEX - My Smart Price Tracker
//
//  Created by Ashish Kapoor on 23/06/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import UIKit

class CXPriceCurrencyVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var lastPrices      = [CXLastPrices]()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Price Currency"
        view.backgroundColor            = UIColor.black
        setupTableView()
        refreshData(sender: refreshControl)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        clearOldData()
    }
    
    func setupTableView() -> Void {
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
        refreshControl.addTarget(self, action: #selector(CXPriceCurrencyVC.refreshData(sender:)), for: .valueChanged)
        let attributes = [ NSForegroundColorAttributeName : UIColor.white ] as [String: Any]
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Data ...", attributes: attributes)
    }
    
    func clearOldData() {
        print(self.lastPrices.description)
        self.lastPrices.removeAll()
    }
    
    func refreshData(sender: UIRefreshControl) {
        if self.lastPrices.count > 0 {
            clearOldData()
            tableView.reloadData()
        }
        loadData()
    }
    
    deinit {
        tableView = nil
    }
    
    func loadData () {
        let url:URL = URL(string: lastPricesURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {print("error=\(String(describing: error))"); return}
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                for (key,value) in (json as? JSONDictionary)! {
                    if key == "data" {
                        guard let valueJSONArray = value as? JSONArray else {return}
                        for pairs in valueJSONArray {
                            self.lastPrices.append(CXLastPrices(priceStatsData: pairs as! JSONDictionary))
                        }
                    }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lastPrices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let priceData = lastPrices[indexPath.row]
        
        cell.backgroundColor = UIColor.black
        cell.textLabel?.text = priceData.lastPrice
        
        if #available(iOS 8.2, *) {
            cell.textLabel?.font = UIFont.systemFont(ofSize: 30, weight: UIFontWeightBold)
        } else {
            // Fallback on earlier versions
            cell.textLabel?.font = UIFont.systemFont(ofSize: 30)
        }
        cell.textLabel?.tintColor = UIColor.white
        cell.textLabel?.textColor = UIColor.white
        
        cell.detailTextLabel?.text = "\(priceData.symbol1) - \(priceData.symbol2)"
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.detailTextLabel?.tintColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        
        return cell
    }
}

