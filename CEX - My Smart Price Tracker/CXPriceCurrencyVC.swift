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
    
    var lastPrices      = CXLastPrices()
    
    var lastPriceArray  = [String]()
    var symbol1Array    = [String]()
    var symbol2Array    = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Price Currency"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        clearOldData()
    }
    
    func clearOldData() -> Void {
        
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
                            self.lastPrices = (CXLastPrices(priceStatsData: pairs as! JSONDictionary))
                            print(self.lastPrices.getLastPrice)
                            self.lastPriceArray.append(self.lastPrices.getLastPrice)
                            self.symbol1Array.append(self.lastPrices.getSymbol1)
                            self.symbol2Array.append(self.lastPrices.getSymbol2)
                        }
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lastPriceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = lastPriceArray[indexPath.row]
//        cell.detailTextLabel?.text = self.lastPrices?.getLastPrice[indexPath.row]
        
        return cell
    }
}

