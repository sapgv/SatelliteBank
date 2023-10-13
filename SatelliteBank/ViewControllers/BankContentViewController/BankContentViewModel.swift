//
//  BankContentViewModel.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import Foundation

protocol IBankContentViewModel: AnyObject {
    
    var office: IOffice { get }
    
    
    
}

final class BankContentViewModel: IBankContentViewModel {
    
    var office: IOffice
    
    init(office: IOffice) {
        self.office = office
    }
    
}
