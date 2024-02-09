//
//  +TextLength.swift
//  Lipsumizer
//
//  Created by Diego Otero on 2024-02-09.
//

import Foundation
import LoremIpsumGenerator

extension TextLength {
    var localizedDescription: String {
        switch unit {
        case .word:
            String(localized: "\(count) Words")
        case .paragraph:
            String(localized: "\(count) Paragraphs")
        }
    }
}
