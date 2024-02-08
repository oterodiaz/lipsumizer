//
//  +String.swift
//
//
//  Created by Diego Otero on 2024-02-08.
//

import Foundation

extension String {
    var words: [String] {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\n", with: " ")
            // Condense whitespaces to just one character
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
            .components(separatedBy: " ")
    }

    var endsWithStrongPunctuation: Bool {
        let strongPunctuation = CharacterSet(arrayLiteral: ".", "!", "?")
        
        return self.endsWith(strongPunctuation)
    }

    var endsWithAnyPunctuation: Bool {
        self.endsWith(.punctuationCharacters)
    }

    private func endsWith(_ charSet: CharacterSet) -> Bool {
        guard let lastCharacter = self.unicodeScalars.last else {
            return false
        }

        return charSet.contains(lastCharacter)
    }
}
