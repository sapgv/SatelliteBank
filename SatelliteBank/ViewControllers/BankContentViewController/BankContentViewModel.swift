//
//  BankContentViewModel.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import Foundation

protocol IBankContentViewModel: AnyObject {
    
    var bank: Bank { get }
    
    
    
}

final class BankContentViewModel: IBankContentViewModel {
    
    var bank: Bank
    
    init(bank: Bank) {
        self.bank = bank
    }
    
}
