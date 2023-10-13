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
                
                let value: Double = i < 8 || i > 20 ? 0 : Double.random(in: 5...8)
                let data = BarChartDataEntry(x: Double(i), y: value)
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
