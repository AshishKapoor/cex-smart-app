//
//  CXChartTVC.swift
//  CEX - My Smart Price Tracker
//
//  Created by Ashish Kapoor on 23/06/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import UIKit

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
        tableView.tableFooterView = UIView()
    }

    @IBAction func timeSegmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            clearOldData()
            loadDataForEth(time: timeStampValue(timePeriod: timeSpan.aDay))
            loadDataForBtc(time: timeStampValue(timePeriod: timeSpan.aDay))
            break
        case 1:
            clearOldData()
            loadDataForEth(time: timeStampValue(timePeriod: timeSpan.aWeek))
            loadDataForBtc(time: timeStampValue(timePeriod: timeSpan.aWeek))
            break
        case 2:
            clearOldData()
            loadDataForEth(time: timeStampValue(timePeriod: timeSpan.aMonth))
            loadDataForBtc(time: timeStampValue(timePeriod: timeSpan.aMonth))
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
            loadDataForEth(time: timeStampValue(timePeriod: timeSpan.aDay))
            loadDataForBtc(time: timeStampValue(timePeriod: timeSpan.aDay))
        }
    }
    
    func clearOldData() -> Void {
        
        self.priceStatsPriceArrayForEth.removeAll()
        self.priceStatsTimeStampArrayForEth.removeAll()
        
        self.priceStatsPriceArrayForBtc.removeAll()
        self.priceStatsTimeStampArrayForBtc.removeAll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        clearOldData()
    }
    
    func loadDataForEth(time: Int) {
        let newURL:URL = URL(string: priceStatsEthURL)!
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
                        self.priceStats = (CXChart(priceStatsData: safePriceStats))
                        self.priceStatsPriceArrayForEth.append(self.priceStats?.getPriceValue ?? 0.0)
                        self.priceStatsTimeStampArrayForEth.append(self.priceStats?.getTimeStampValue ?? "")
                        DispatchQueue.global(qos: .background).async {
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            } catch {}
        }
        task.resume()
    }
    
    func loadDataForBtc(time: Int) {
        let newURL:URL = URL(string: priceStatsBtcURL)!
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
                        self.priceStats = (CXChart(priceStatsData: safePriceStats))
                        self.priceStatsPriceArrayForBtc.append(self.priceStats?.getPriceValue ?? 0.0)
                        self.priceStatsTimeStampArrayForBtc.append(self.priceStats?.getTimeStampValue ?? "")
                        DispatchQueue.global(qos: .background).async {
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? CXChartTVCell else {return UITableViewCell()}
        
        if indexPath.row == 0 {
            cell.currencyLabel.text = priceCurrency.first
            cell.setChart(dataPoints: self.priceStatsTimeStampArrayForBtc, values: self.priceStatsPriceArrayForBtc)
            cell.addXValuesToBarChartView(time: self.priceStatsTimeStampArrayForBtc)
        } else {
            cell.currencyLabel.text = priceCurrency.last
            cell.setChart(dataPoints: self.priceStatsTimeStampArrayForEth, values: self.priceStatsPriceArrayForEth)
            cell.addXValuesToBarChartView(time: self.priceStatsTimeStampArrayForEth)
        }
        return cell
    }
}
