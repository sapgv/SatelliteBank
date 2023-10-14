//
//  BankContentViewModel.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import Foundation

protocol IBankContentViewModel: AnyObject {
    
    var office: IOffice { get }
    
    var delegate: IBankContentViewControllerDelegate? { get set }
    
    func findFreeOfficeNear() -> IOffice?
    
}

final class BankContentViewModel: IBankContentViewModel {
    
    var office: IOffice
    
    weak var delegate: IBankContentViewControllerDelegate?
    
    init(office: IOffice) {
        self.office = office
    }
    
    func findFreeOfficeNear() -> IOffice? {
        
        guard let delegate = self.delegate else { return nil }
        
        var officeMinDistance: Double?
        var officeWithMinDistance: IOffice?
        
        for newOffice in delegate.offices {
            guard newOffice.coordinate != self.office.coordinate else { continue }
            guard newOffice.load != .high else { continue }
            let distance = self.office.location.distance(from: newOffice.location)
            guard distance < 1000 else { continue }
            guard let minDistance = officeMinDistance else {
                officeMinDistance = distance
                officeWithMinDistance = newOffice
                continue
            }
            
            if distance < minDistance {
                officeMinDistance = distance
                officeWithMinDistance = newOffice
            }
        }
        
        return officeWithMinDistance
        
    }
    
}
