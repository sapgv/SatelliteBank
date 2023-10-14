//
//  ChartData + Extensions.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import DGCharts

extension ChartData {
    
    static func generate(office: IOffice, color: UIColor) -> [ChartData] {
        
        var dataArray: [ChartData] = []
        
        for _ in 0..<7 {
            
            var array: [BarChartDataEntry] = []
            
            let hourRange = 6...22
            
            let randomCurrentHour: Int = Int.random(in: 10...17)
            
            for i in hourRange {
                
                let range: ClosedRange<Double>
                
                switch i {
                case 0...7:
                    range = 0...0
                case 8...12:
                    range = 6...10
                case 12...16:
                    range = 10...13
                case 16...20:
                    range = 15...25
                default:
                    range = 0...0
                }
                
                var randomValue = Double.random(in: range)
                
                let pastRandowValue = Double.random(in: 0.9...1.1) * randomValue
                
                let data: BarChartDataEntry
                
                if i == randomCurrentHour {
                    let pastRandowValue = Double.random(in: 0.9...1.1) * Double(office.queue)
                    data = BarChartDataEntry(x: Double(i), yValues: [Double(office.queue), pastRandowValue])
                }
                else {
                    
                    data = BarChartDataEntry(x: Double(i), yValues: [0, pastRandowValue])
                }
                
                array.append(data)
                
            }
            
            let set = BarChartDataSet(entries: array)
            set.colors = [NSUIColor(cgColor: color.cgColor), NSUIColor(cgColor: UIColor.lightGray.cgColor)]
            set.label = ""
            set.stackLabels = ["Текущая очередь", "Обычно очередь"]
            
            let data = BarChartData(dataSet: set)
            data.setDrawValues(false)
            
            dataArray.append(data)
        }
        
        return dataArray
        
    }
    
}
