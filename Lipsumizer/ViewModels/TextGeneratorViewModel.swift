//
//  TextGeneratorViewModel.swift
//  Lipsumizer
//
//  Created by Diego Otero on 2024-02-08.
//

import SwiftUI
import LoremIpsumGenerator

@Observable
class TextGeneratorViewModel {
    
    var generator: LoremIpsumGenerator
    
    var output: String
    var textLength: TextLength
    var beginWithLoremIpsum: Bool
    
    var canBeginWithLoremIpsum: Bool {
        beginWithLoremIpsum && !generator.isUsingCustomText
    }
    
    init(
        generator: LoremIpsumGenerator = LoremIpsumGenerator(),
        output: String = "",
        textLength: TextLength = .init(unit: .paragraph, count: 3),
        beginWithLoremIpsum: Bool = true
    ) {
        self.generator = generator
        self.output = output
        self.textLength = textLength
        self.beginWithLoremIpsum = beginWithLoremIpsum
    }
    
    func runGenerator() {
        Task { @MainActor in
            output = await generator.generateText(
                length: textLength,
                firstWordPair: canBeginWithLoremIpsum ? .init("Lorem", "ipsum") : nil
            )
        }
    }
    
    func decreaseTextLength() {
        textLength.count = max(1, textLength.count - 1)
    }
    
    func increaseTextLength() {
        textLength.count = max(1, textLength.count + 1)
    }
    
    func toggleLengthUnit() {
        if textLength.unit == .word {
            textLength.unit = .paragraph
            textLength.count = 3
        } else {
            textLength.unit = .word
            textLength.count = 70
        }
    }
    
    var navigationTitle: String {
        textLength.localizedDescription
    }
}
