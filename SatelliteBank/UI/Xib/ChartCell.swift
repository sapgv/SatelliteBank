//
//  ChartCell.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import UIKit
import DGCharts

class ChartCell: UITableViewCell {

    static let id = "ChartCell"
    
    @IBOutlet weak var chartView: BarChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.chartView.leftAxis.enabled = false
        self.chartView.rightAxis.enabled = false
        self.chartView.xAxis.labelPosition = .bottom
        self.chartView.dragEnabled = false
        self.chartView.backgroundColor = .white
        self.chartView.doubleTapToZoomEnabled = false
        self.chartView.pinchZoomEnabled = false
    }
    
    func setup() {
        
//        self.setDataCount(1, range: 5)
        
        self.setupData()
        
    }
    
    private func setupData() {
        
        var array: [BarChartDataEntry] = []
        
        for i in 1...24 {
            
            let value: Double = i < 8 || i > 20 ? 0 : Double.random(in: 5...8)
            let data = BarChartDataEntry(x: Double(i), y: value)
            array.append(data)
            
        }
        
        let set = BarChartDataSet(entries: array)
        set.colors = [NSUIColor(cgColor: AppColor.primary.cgColor)]
        set.label = "Посещаемость"
        let data = BarChartData(dataSet: set)
        data.setDrawValues(false)
        
        chartView.data = data
        
    }
    
//    override func updateChartData() {
//        if self.shouldHideData {
//            chartView.data = nil
//            return
//        }
//
//
//    }
    
//    func setDataCount(_ count: Int, range: UInt32) {
//        let start = 1
//
////        let yVals = (start..<start+count+1).map { (i) -> BarChartDataEntry in
////            let mult = range + 1
////            let val = Double(arc4random_uniform(mult))
////            if arc4random_uniform(100) < 25 {
////                return BarChartDataEntry(x: Double(i), y: val, icon: UIImage(named: "icon"))
////            } else {
////                return BarChartDataEntry(x: Double(i), y: val)
////            }
////        }
//
//        let yVals: [BarChartDataEntry] = [
//            BarChartDataEntry(x: 1, y: 5),
//            BarChartDataEntry(x: 2, y: 6),
//            BarChartDataEntry(x: 3, y: 5.5),
//            BarChartDataEntry(x: 4, y: 4),
//            BarChartDataEntry(x: 5, y: 6.1),
//        ]
//
//
//        var set1: BarChartDataSet! = nil
//        if let set = chartView.data?.first as? BarChartDataSet {
////            set1 = set
////            set1.replaceEntries(yVals)
////            chartView.data?.notifyDataChanged()
////            chartView.notifyDataSetChanged()
//        } else {
//            set1 = BarChartDataSet(entries: yVals, label: "The year 2017")
//            set1.colors = ChartColorTemplates.material()
//            set1.drawValuesEnabled = false
//
//            let data = BarChartData(dataSet: set1)
//            data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
//            data.barWidth = 1
//            chartView.data = data
//        }
//
////        chartView.setNeedsDisplay()
//    }
    
}
