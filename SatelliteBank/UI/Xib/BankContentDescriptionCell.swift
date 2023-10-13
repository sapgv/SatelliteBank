//
//  BankContentDescriptionCell.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import UIKit

class BankContentDescriptionCell: UITableViewCell {

    static let id = "BankContentDescriptionCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var button: ScheduleButton!
    
    @IBOutlet weak var closeButton: CloseButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.button.setTitle("Записаться на посещение", for: .normal)
    }
    
    func setup(office: IOffice) {
        
        self.titleLabel.text = office.salePointName
        self.addressLabel.text = office.address
        
        
    }
    
}
