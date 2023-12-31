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
    
    @IBOutlet var dayButtons: [UIButton]!
    
    var showFreeOfficeAction: ((IOffice) -> Void)?
    
    private var charData: [ChartData] = []
    
    private var index: Int = 0
    
    private var office: IOffice?
    
    @IBOutlet weak var loadImageView: UIImageView!
    
    @IBOutlet weak var waitLabel: UILabel!
    
    @IBOutlet weak var loadLabel: UILabel!
    
    @IBOutlet weak var freeOfficeButton: FreeOfficeButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.chartView.leftAxis.enabled = false
        self.chartView.fitBars = true
        self.chartView.rightAxis.enabled = false
        self.chartView.xAxis.labelPosition = .bottom
        self.chartView.dragEnabled = false
        self.chartView.backgroundColor = .systemBackground
        self.chartView.doubleTapToZoomEnabled = false
        self.chartView.pinchZoomEnabled = false
        for button in self.dayButtons {
            button.layer.cornerRadius = 4
            button.clipsToBounds = true
        }
    }
    
    func setup(office: IOffice) {
        self.office = office
        self.freeOfficeButton.isHidden = office.load == .medium || office.load == .low
        self.charData = ChartData.generate(office: office, color: office.load.color)
        self.setupLabels()
        self.updateChart(index: self.index)
    }
    
    @IBAction func daySelect(_ sender: UIButton) {
        self.index = sender.tag
        self.updateChart(index: sender.tag)
    }
    
    @IBAction func showFreeOffice(_ sender: Any) {
        guard let office = self.office else { return }
        self.showFreeOfficeAction?(office)
    }
    
    private func setupLabels() {
        guard let office = self.office else { return }
        self.loadImageView.image = office.iconImage
        self.loadLabel.text = office.load.title
        self.loadLabel.textColor = office.load.color
        self.waitLabel.text = office.load.waitTitle
        
    }
    
    private func updateChart(index: Int) {
        chartView.data = self.charData[index]
        for button in self.dayButtons {
            button.backgroundColor = button.tag == self.index ? UIColor.secondarySystemBackground : .systemBackground
        }
    }
    
}

