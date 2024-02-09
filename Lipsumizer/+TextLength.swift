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
        switch self {
        case .word(let count):
            String(localized: "\(count) Words")
        case .paragraph(let count):
            String(localized: "\(count) Paragraphs")
        }
    }
}
