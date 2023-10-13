//
//  ChartData + Extensions.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import DGCharts

extension ChartData {
    
    static func generate() -> [ChartData] {
        
        var dataArray: [ChartData] = []
        
        for _ in 0..<7 {
            
            var array: [BarChartDataEntry] = []
            
            for i in 1...24 {
                
                let range: ClosedRange<Double>
                
                switch i {
                case 0...7:
                    range = 0...0
                case 8...12:
                    range = 1...3
                case 12...16:
                    range = 2...4
                case 16...20:
                    range = 4...6
                default:
                    range = 0...0
                }
                
                let randomValue = Double.random(in: range)
                
                let data = BarChartDataEntry(x: Double(i), y: randomValue)
                
                array.append(data)
                
            }
            
            let set = BarChartDataSet(entries: array)
            set.colors = [NSUIColor(cgColor: AppColor.primary.cgColor)]
            set.label = "Посещаемость"
            
            let data = BarChartData(dataSet: set)
            data.setDrawValues(false)
            
            dataArray.append(data)
        }
        
        return dataArray
        
    }
    
}
