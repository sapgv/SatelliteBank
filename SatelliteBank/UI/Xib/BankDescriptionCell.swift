//
//  BankDescriptionCell.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 15.10.2023.
//

import UIKit

class BankDescriptionCell: UITableViewCell {

    static let id = "BankDescriptionCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var closeButton: CloseButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setup(office: IOffice) {
        
        self.titleLabel.text = office.salePointName
        self.addressLabel.text = office.address
        
        
    }
    
    
}
