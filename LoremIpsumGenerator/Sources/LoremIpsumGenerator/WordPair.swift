//
//  WordPair.swift
//  
//
//  Created by Diego Otero on 2024-02-08.
//

import Foundation

public struct WordPair: Hashable {
    
    public let firstWord:  String
    public let secondWord: String

    public init(_ firstWord: String, _ secondWord: String) {
        self.firstWord  = firstWord
        self.secondWord = secondWord
    }
}
