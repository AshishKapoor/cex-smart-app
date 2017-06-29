//
//  CXPriceCurrencyVC.swift
//  CEX - My Smart Price Tracker
//
//  Created by Ashish Kapoor on 23/06/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CXPriceCurrencyVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var lastPrices      = [CXLastPrices]()
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Price Currency"
        view.backgroundColor            = UIColor.black
        setupTableView()

        setupAdMob()
    }
 
    
    func setupAdMob() {
//        let request = GADRequest()
//        request.testDevices = [kGADSimulatorID]
        
        bannerView.adUnitID = "ca-app-pub-1816315233369355/9965504421"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
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
        tableView.estimatedRowHeight    = 50.0
        
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
        refreshControl.attributedTitle = NSAttributedString(string: "Updating ...", attributes: attributes)
    }
    
    func clearOldData() {
        self.lastPrices.removeAll()
        tableView.reloadData()
    }
    
    func refreshData(sender: UIRefreshControl) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if self.lastPrices.count > 0 {
            clearOldData()
        }
        loadData()
    }
    
    func updateView() {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
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
                            self.lastPrices.append(CXLastPrices(json: pairs as! JSONDictionary))
                        }
                    }
                }
                self.updateView()
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
        cell.textLabel?.textColor = UIColor.appGreen()
        
        cell.detailTextLabel?.text = "\(priceData.symbol1) - \(priceData.symbol2)"
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        
        if priceData.symbol2 == "USD" {
            cell.detailTextLabel?.textColor = UIColor(colorLiteralRed: 0, green: 150, blue: 100, alpha: 0.6)
        } else if priceData.symbol2 == "EUR" {
            cell.detailTextLabel?.textColor = UIColor(colorLiteralRed: 150, green: 100, blue: 0, alpha: 0.6)
        } else {
            cell.detailTextLabel?.textColor = UIColor.lightGray
        }
        
        
        return cell
    }
}

