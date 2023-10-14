//
//  BonusService.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 14.10.2023.
//

import Foundation

protocol IBonusService: AnyObject {
    
    var bonuses: [IBonus] { get }
    
    static var shared: IBonusService { get }
    
    func update(_ completion: ((NSError?) -> Void)?)
    
    func clear()
    
}

extension IBonusService {
    
    func update(_ completion: ((NSError?) -> Void)? = nil) {
        self.update(completion)
    }
    
}

final class BonusService: IBonusService {
    
    private(set) var bonuses: [IBonus] = []
    
    static let shared: IBonusService = BonusService()
    
    private let accessQueue = DispatchQueue(label: "accessQueue", attributes: .concurrent)
    
    private init() {}
    
    func update(_ completion: ((NSError?) -> Void)? = nil) {
        
        self.accessQueue.async {
            
            guard let url = Bundle.main.url(forResource: "offices", withExtension: "txt") else { return }
            
            do {
                let data = try Data(contentsOf: url)
                guard let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] else { return }
                let bonuses = array.map { Bonus(data: $0) }
                self.accessQueue.async(flags: .barrier) {
                    self.bonuses = bonuses
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
        self.bonuses.removeAll()
    }
    
}
