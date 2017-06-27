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
    
    var priceStatsPriceArray = [Double]()
    var priceStatsTimeStampArray = [String]()
    
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
            loadData(time: timeStampValue(timePeriod: timeSpan.aDay))
            break
        case 1:
            clearOldData()
            loadData(time: timeStampValue(timePeriod: timeSpan.aWeek))
            break
        case 2:
            clearOldData()
            loadData(time: timeStampValue(timePeriod: timeSpan.aMonth))
            break
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !(self.priceStatsPriceArray.isEmpty) {
            clearOldData()
        } else {
            timeSegmentControl.selectedSegmentIndex = 0
            loadData(time: timeStampValue(timePeriod: timeSpan.aDay))
        }
    }
    
    func clearOldData() -> Void {
        self.priceStatsPriceArray.removeAll()
        self.priceStatsTimeStampArray.removeAll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        clearOldData()
    }
    
    func loadData(time: Int) {
        let url:URL = URL(string: priceStatsURL)!
        var request = URLRequest(url: url)
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
                        self.priceStatsPriceArray.append(self.priceStats?.getPriceValue ?? 0.0)
                        self.priceStatsTimeStampArray.append(self.priceStats?.getTimeStampValue ?? "")
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
        
        cell.currencyLabel.text = ["BTC/USD",  "ETH/USD"][indexPath.row]
        cell.setChart(dataPoints: self.priceStatsTimeStampArray, values: self.priceStatsPriceArray)
        cell.addXValuesToBarChartView(time: self.priceStatsTimeStampArray)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
