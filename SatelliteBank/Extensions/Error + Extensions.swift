//
//  Error + Extensions.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import Foundation

extension Error {
    
    var NSError: NSError {
        return Foundation.NSError(domain: "Error", code: 0, userInfo: [NSLocalizedDescriptionKey: self.localizedDescription])
    }
    
}
