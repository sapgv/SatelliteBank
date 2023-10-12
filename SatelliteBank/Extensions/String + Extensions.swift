//
//  String + Extensions.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 12.10.2023.
//

import Foundation

extension String {
    
    func phoneRu() -> String {
        guard self != "7" && self != "8" else { return "+ 7" }
        return numberFormat(prefix: "+ 7", mask: " (XXX) XXX-XX-XX")
    }
    
    func numberFormat(prefix: String = "", mask: String) -> String {
        let string = !prefix.isEmpty && self.hasPrefix(prefix) ? String(self[self.index(startIndex, offsetBy: prefix.count)...]) : self
        let cleanNumber = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        var result = ""
        var index = cleanNumber.startIndex
        for ch in mask {
            if index == cleanNumber.endIndex {
                break
            }
            if ch == "X" {
                result.append(cleanNumber[index])
                index = cleanNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return prefix + result
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    var isValidPhone: Bool {
        let cleanNumber = self.cleanNumber()
        return !cleanNumber.isEmpty && cleanNumber.hasPrefix("7") && cleanNumber.count == 11
    }
    
    func cleanNumber() -> String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
}

extension Optional where Wrapped == String {
    
    var isValidPhone: Bool {
        guard let self = self else { return false }
        return self.isValidPhone
    }
    
}
