//
//  ButtonCell.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 15.10.2023.
//

import UIKit

class ButtonCell: UITableViewCell {

    static let id = "ButtonCell"
    
    @IBOutlet weak var button: PrimaryButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.button.layer.cornerRadius = 8
        self.button.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
