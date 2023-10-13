//
//  AddRouteCell.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import UIKit

class AddRouteCell: UITableViewCell {

    static let id: String = "AddRouteCell"
    
    @IBOutlet weak var addRouteButton: PrimaryButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addRouteButton.layer.cornerRadius = 8
        self.addRouteButton.clipsToBounds = true
        self.addRouteButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }

    
}
