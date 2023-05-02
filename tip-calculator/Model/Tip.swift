//
//  Tip.swift
//  tip-calculator
//
//  Created by Sam Sung on 2023/05/02.
//

import Foundation

enum Tip {
    case none
    case tenPercent
    case fifteenPercent
    case twentyPercent
    case cutsom(value: Int)
    
    var stringValue: String {
        switch self {
        case .none:
            return ""
        case .tenPercent:
            return "10%"
        case .fifteenPercent:
            return "15%"
        case .twentyPercent:
            return "20%"
        case .cutsom(value: let value):
            return String(value)
        }
    }

}
