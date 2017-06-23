//
//  CXChartTVCell.swift
//  CEX - My Smart Price Tracker
//
//  Created by Ashish Kapoor on 23/06/17.
//  Copyright © 2017 Ashish Kapoor. All rights reserved.
//

import UIKit
import Charts

class CXChartTVCell: UITableViewCell, ChartViewDelegate {

    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var lineChartView: LineChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lineChartView.delegate = self
        setupChartView()
    }
    
    func setupChartView() -> Void {
        lineChartView.backgroundColor      = UIColor.white
        lineChartView.layer.borderWidth    = 0.25
        lineChartView.layer.cornerRadius   = 5
        lineChartView.layer.shadowColor    = UIColor.gray.cgColor
    }
    
    func addXValuesToBarChartView(time: [String]) {
        lineChartView.xAxis.labelCount = time.count
        lineChartView.xAxis.labelTextColor = UIColor.black
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        lineChartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        
        for points in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(points), yValues: [values[points]])
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "ETH - USD conversion")
//        lineChartDataSet.colors = ChartColorTemplates.colorful()
        lineChartDataSet.colors = [UIColor.green]
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("Entry X: \(entry.x)")
        print("Entry Y: \(entry.y)")
        print("Highlight X: \(highlight.x)")
        print("Highlight Y: \(highlight.y)")
        print("DataIndex: \(highlight.dataIndex)")
        print("DataSetIndex: \(highlight.dataSetIndex)")
        print("StackIndex: \(highlight.stackIndex)\n\n")
    }
    
//    public func stringForValue(value: Double, axis: AxisBase?) -> String {
//        return priceStatsTimeStampArray[Int(value)]
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
