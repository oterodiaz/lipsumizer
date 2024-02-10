//
//  UserDefaultsKey.swift
//  Lipsumizer
//
//  Created by Diego Otero on 2024-02-10.
//

import Foundation

enum UserDefaultsKey: String, CaseIterable {
    case beginWithLoremIpsum
    case genWordsOnLaunch
    case initialParagraphCount
    case initialWordCount
    case genFromCustomText
    case customText
    
    var string: String {
        self.rawValue
    }
}

