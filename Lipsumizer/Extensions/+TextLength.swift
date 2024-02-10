//
//  +TextLength.swift
//  Lipsumizer
//
//  Created by Diego Otero on 2024-02-09.
//

import Foundation
import LoremIpsumGenerator

extension TextLength {
    
    var reachedMaxLength: Bool {
        switch unit {
        case .word:
            count >= 10_000
        case .paragraph:
            count >= 1_000
        }
    }
    
    var localizedDescription: String {
        switch unit {
        case .word:
            String(localized: "\(count) Words")
        case .paragraph:
            String(localized: "\(count) Paragraphs")
        }
    }
}
