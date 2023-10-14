//
//  ScheduleTimeCell.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 15.10.2023.
//

import UIKit

class ScheduleTimeCell: UITableViewCell {

    static let id = "ScheduleTimeCell"
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

}
