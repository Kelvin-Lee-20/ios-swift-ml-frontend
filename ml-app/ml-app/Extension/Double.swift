//
//  Double.swift
//  ml-app
//
//  Created by Kelvin on 30/7/2025.
//

import Foundation

extension Double {
    
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func trimmedToTwoDecimalPlaces() -> Double {
        return (self * 100).rounded(.down) / 100
    }
    
}
