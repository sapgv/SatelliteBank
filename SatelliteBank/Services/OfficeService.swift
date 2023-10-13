//
//  OfficeService.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import Foundation

protocol IOfficeService: AnyObject {
    
    var offices: [IOffice] { get }
    
    static var shared: IOfficeService { get }
    
    func update(_ completion: ((NSError?) -> Void)?)
    
    func clear()
    
}

extension IOfficeService {
    
    func update(_ completion: ((NSError?) -> Void)? = nil) {
        self.update(completion)
    }
    
}

final class OfficeService: IOfficeService {
    
    private(set) var offices: [IOffice] = []
    
    static let shared: IOfficeService = OfficeService()
    
    private let accessQueue = DispatchQueue(label: "accessQueue", attributes: .concurrent)
    
    private init() {}
    
    func update(_ completion: ((NSError?) -> Void)? = nil) {
        
        self.accessQueue.async {
            
            guard let url = Bundle.main.url(forResource: "offices", withExtension: "txt") else { return }
            
            do {
                let data = try Data(contentsOf: url)
                guard let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] else { return }
                let offices = array.map { Office(data: $0) }
                self.accessQueue.async(flags: .barrier) {
                    self.offices = offices
                    Thread.main {
                        completion?(nil)
                    }
                }
            } catch {
                Thread.main {
                    completion?(error.NSError)
                }
            }
            
        }
        
    }
    
    func clear() {
        self.offices.removeAll()
    }
    
}
