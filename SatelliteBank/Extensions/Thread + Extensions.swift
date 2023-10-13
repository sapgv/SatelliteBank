//
//  Thread + Extensions.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import Foundation

public extension Thread {
    class func run(execute: @escaping @convention(block) () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async(execute: execute)
    }
    
    class func run(execute: DispatchWorkItem) {
        DispatchQueue.global(qos: .userInitiated).async(execute: execute)
    }
    
    class func main(execute: @escaping @convention(block) () -> Void) {
        DispatchQueue.main.async(execute: execute)
    }
    
    class func main(execute: DispatchWorkItem) {
        DispatchQueue.main.async(execute: execute)
    }
    
}
