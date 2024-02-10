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
        textLength: TextLength = .init(unit: defaultTextLengthUnit(), count: defaultTextLength()),
        beginWithLoremIpsum: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKey.beginWithLoremIpsum.string)
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
    
    func setTextLengthCount(_ newValue: Int) {
        textLength.count = textLength.unit == .word ? min(10_000, max(1, newValue)) : min(1_000, max(1, newValue))
    }
    
    func decreaseTextLength() {
        setTextLengthCount(textLength.count - 1)
    }
    
    func increaseTextLength() {
        setTextLengthCount(textLength.count + 1)
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

fileprivate func defaultTextLengthUnit() -> TextLength.LengthUnit {
    UserDefaults.standard.bool(forKey: UserDefaultsKey.genWordsOnLaunch.string) ? .word : .paragraph
}

fileprivate func defaultTextLength() -> Int {
    if UserDefaults.standard.bool(forKey: UserDefaultsKey.genWordsOnLaunch.string) {
        UserDefaults.standard.integer(forKey: UserDefaultsKey.initialWordCount.string)
    } else {
        UserDefaults.standard.integer(forKey: UserDefaultsKey.initialParagraphCount.string)
    }
}
