//
//  TextLength.swift
//
//
//  Created by Diego Otero on 2024-02-08.
//

import Foundation

public struct TextLength {
    
    public var count: Int
    public var unit: LengthUnit
    
    public init(unit: LengthUnit, count: Int) {
        self.count = count
        self.unit = unit
    }
    
    public enum LengthUnit {
        case word
        case paragraph
    }
}
