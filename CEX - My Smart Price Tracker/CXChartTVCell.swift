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
        lineChartView.xAxis.labelTextColor  = UIColor.barGraphChartColor()
        lineChartView.xAxis.axisRange       = Double(time.count)
    }
    
    func setChartBtc(dataPoints: [String], values: [Double]) {
        lineChartView.noDataText        = "You need to provide data for the chart."
        lineChartView.noDataTextColor   = UIColor.black
        
        var dataEntries: [BarChartDataEntry] = []
        
        for points in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(points), yValues: [values[points]])
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "BTC/USD")
//        lineChartDataSet.colors = ChartColorTemplates.colorful()
        lineChartDataSet.colors                 = [UIColor.red]
        lineChartDataSet.circleColors           = [UIColor.green]
        lineChartDataSet.circleRadius           = 2.0
//        lineChartDataSet.drawCirclesEnabled     = false
        lineChartDataSet.lineWidth              = 1.0
        lineChartDataSet.valueFont              = UIFont.systemFont(ofSize: 8.0)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        lineChartView.animate(xAxisDuration: 0.25, easingOption: .easeInBack)
        lineChartView.chartDescription?.text = ""
//        lineChartView.chartDescription?.font = UIFont.systemFont(ofSize: 12)
    }
    
    func setChartEth(dataPoints: [String], values: [Double]) {
        lineChartView.noDataText        = "You need to provide data for the chart."
        lineChartView.noDataTextColor   = UIColor.black
        
        var dataEntries: [BarChartDataEntry] = []
        
        for points in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(points), yValues: [values[points]])
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "ETH/USD")
        //         lineChartDataSet.colors = ChartColorTemplates.colorful()
        lineChartDataSet.colors                 = [UIColor.green]
        lineChartDataSet.circleColors           = [UIColor.red]
        lineChartDataSet.circleRadius           = 2.0
        //        lineChartDataSet.drawCirclesEnabled     = false
        lineChartDataSet.lineWidth              = 1.0
        lineChartDataSet.valueFont              = UIFont.systemFont(ofSize: 8.0)
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        lineChartView.data = lineChartData
        lineChartView.animate(xAxisDuration: 0.25, easingOption: .easeInBack)
        lineChartView.chartDescription?.text = ""
//        lineChartView.chartDescription?.font = UIFont.systemFont(ofSize: 12)
        
    }
    
//    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
//        print("Entry X: \(entry.x)")
//        print("Entry Y: \(entry.y)")
//        print("Highlight X: \(highlight.x)")
//        print("Highlight Y: \(highlight.y)")
//        print("DataIndex: \(highlight.dataIndex)")
//        print("DataSetIndex: \(highlight.dataSetIndex)")
//        print("StackIndex: \(highlight.stackIndex)\n\n")
//    }
    
//    public func stringForValue(value: Double, axis: AxisBase?) -> String {
//        return priceStatsTimeStampArray[Int(value)]
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
