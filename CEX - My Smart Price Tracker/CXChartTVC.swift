//
//  CXChartTVC.swift
//  CEX - My Smart Price Tracker
//
//  Created by Ashish Kapoor on 23/06/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import UIKit
import Firebase

class CXChartTVC: UITableViewController {

    var priceStats: CXChart?
    
    var priceStatsPriceArrayForEth      = [Double]()
    var priceStatsTimeStampArrayForEth  = [String]()
    
    var priceStatsPriceArrayForBtc      = [Double]()
    var priceStatsTimeStampArrayForBtc  = [String]()
    
    var priceCurrency                   = ["BTC/USD","ETH/USD"]
    
    @IBOutlet weak var timeSegmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Charts"
        view.backgroundColor = UIColor.white
        tableView.backgroundColor = UIColor.white
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.tableFooterView = UIView()
    }

    @IBAction func timeSegmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            clearOldData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            loadData(time: timeStampValue(timePeriod: timeSpan.aDay), url: priceStatsEthURL)
            loadData(time: timeStampValue(timePeriod: timeSpan.aDay), url: priceStatsBtcURL)
            break
        case 1:
            clearOldData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            loadData(time: timeStampValue(timePeriod: timeSpan.aWeek), url: priceStatsBtcURL)
            loadData(time: timeStampValue(timePeriod: timeSpan.aWeek), url: priceStatsEthURL)
            break
        case 2:
            clearOldData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            loadData(time: timeStampValue(timePeriod: timeSpan.aMonth), url: priceStatsBtcURL)
            loadData(time: timeStampValue(timePeriod: timeSpan.aMonth), url: priceStatsEthURL)
            break
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !(self.priceStatsPriceArrayForEth.isEmpty) {
            clearOldData()
        } else {
            timeSegmentControl.selectedSegmentIndex = 0
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            loadData(time: timeStampValue(timePeriod: timeSpan.aDay), url: priceStatsEthURL)
            loadData(time: timeStampValue(timePeriod: timeSpan.aDay), url: priceStatsBtcURL)
        }
    }
    
    func clearOldData() -> Void {
        self.priceStatsPriceArrayForEth.removeAll()
        self.priceStatsTimeStampArrayForEth.removeAll()
        
        self.priceStatsPriceArrayForBtc.removeAll()
        self.priceStatsTimeStampArrayForBtc.removeAll()
        updateView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        clearOldData()
    }
    
    func updateView() {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    func loadData(time: Int, url: String) {
        
        let newURL:URL = URL(string: url)!
        var request = URLRequest(url: newURL)
        request.httpMethod = "POST"
        let postString = "lastHours=\(time)&maxRespArrSize=10"
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }; do {
                let json = try JSONSerialization.jsonObject(with: data)
                if response != nil {
                    guard let responseArray = json as? JSONArray else {return}
                    for responsePriceStats in responseArray {
                        guard let safePriceStats = responsePriceStats as? JSONDictionary else {return}
                        self.priceStats = (CXChart(json: safePriceStats))
                        
                        if url == priceStatsBtcURL {
                            self.priceStatsPriceArrayForBtc.append(self.priceStats?.getPriceValue ?? 0.0)
                            self.priceStatsTimeStampArrayForBtc.append(self.priceStats?.getTimeStampValue ?? "")
                        } else {
                            self.priceStatsPriceArrayForEth.append(self.priceStats?.getPriceValue ?? 0.0)
                            self.priceStatsTimeStampArrayForEth.append(self.priceStats?.getTimeStampValue ?? "")
                        }
                        
                        self.updateView()
                    }
                }
            } catch {}
        }
        task.resume()
    }
      
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priceCurrency.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? CXChartTVCell else {return UITableViewCell()}
        
        if indexPath.row == 0 {
            cell.currencyLabel.text = priceCurrency.first
            cell.currencyLabel.textColor = UIColor.appGreen()
            if #available(iOS 8.2, *) {
                cell.currencyLabel.font = UIFont.systemFont(ofSize: 30, weight: UIFontWeightBold)
            } else {
                // Fallback on earlier versions
                cell.currencyLabel.font = UIFont.systemFont(ofSize: 30)
            }
            cell.setChartBtc(dataPoints: self.priceStatsTimeStampArrayForBtc, values: self.priceStatsPriceArrayForBtc)
            cell.addXValuesToBarChartView(time: self.priceStatsTimeStampArrayForBtc)
            
        } else {
            cell.currencyLabel.text = priceCurrency.last
            cell.currencyLabel.textColor = UIColor.appGreen()
            if #available(iOS 8.2, *) {
                cell.currencyLabel.font = UIFont.systemFont(ofSize: 30, weight: UIFontWeightBold)
            } else {
                // Fallback on earlier versions
                cell.currencyLabel.font = UIFont.systemFont(ofSize: 30)
            }
            cell.setChartEth(dataPoints: self.priceStatsTimeStampArrayForEth, values: self.priceStatsPriceArrayForEth)
            cell.addXValuesToBarChartView(time: self.priceStatsTimeStampArrayForEth)
            
        }
        return cell
    }
}
