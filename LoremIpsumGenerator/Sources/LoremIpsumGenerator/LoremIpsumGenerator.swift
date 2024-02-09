//
//  LoremIpsumGenerator.swift
//  Lorem Ipsum
//
//  Created by Otero Díaz on 2023-03-20.
//

import Foundation

typealias Word = String

public struct LoremIpsumGenerator {
    
    /// Dictionary containing the list of words that appear after a word pair somewhere in the original text.
    ///
    /// **Example:** The text "Lorem ipsum dolor" would be saved as `WordPair("Lorem", "ipsum") = ["dolor"]`
    ///
    /// **Note:** The words are stored in an array instead of a set (sets don't allow repeats)  in order to account for how common
    /// a certain sequence of words is in the original text.
    private var wordsMarkovChain: [WordPair: [Word]] = [:]
    
    public var isUsingCustomText: Bool

    public init() {
        self.isUsingCustomText = false
        
        let loremIpsumURL  = Bundle.module.url(forResource: "lorem-ipsum",  withExtension: "txt")!
        let liberPrimusURL = Bundle.module.url(forResource: "liber-primus", withExtension: "txt")!
        
        let loremIpsum  = try! String(contentsOf: loremIpsumURL)
        let liberPrimus = try! String(contentsOf: liberPrimusURL)

        populateMarkovChain(from: loremIpsum)
        populateMarkovChain(from: liberPrimus)
    }
    
    public init(fromCustomText text: String) {
        self.isUsingCustomText = true
        populateMarkovChain(from: text)
    }
    
    public init(fromCustomTexts texts: [String]) {
        self.isUsingCustomText = true
        texts.forEach { populateMarkovChain(from: $0) }
    }

    private mutating func populateMarkovChain(from text: String) {
        // Filter out "words" that don't contain alphanumeric characters, such as "--"
        let words = text.words.filter { $0.rangeOfCharacter(from: .alphanumerics) != nil }

        guard words.count >= 3 else { return }

        for i in 0..<(words.count - 2) {
            let wordPair = WordPair(words[i], words[i + 1])
            let (key, value) = (wordPair, words[i + 2])
            
            wordsMarkovChain[key, default: []].append(value)
        }
    }

    public func generateText(
        length: TextLength = .init(unit: .paragraph, count: 3),
        firstWordPair: WordPair? = nil
    ) async -> String {
        
        guard !wordsMarkovChain.isEmpty else { return "" }
        
        switch length.unit {
        case .word:
            return generateSentence(wordCount: length.count, firstWordPair: firstWordPair)
        case .paragraph:
            guard length.count > 0 else { return "" }
            
            let firstParagraph = generateSentence(
                wordCount: .random(in: 30...70),
                firstWordPair: firstWordPair
            )
            
            guard length.count > 1 else { return firstParagraph}
            
            let paragraphs = await withTaskGroup(of: String.self) { group -> [String] in
                for _ in 0..<(length.count - 1) {
                    group.addTask { generateSentence(wordCount: .random(in: 30...70)) }
                }
                
                var paragraphs: [String] = []
                
                for await paragraph in group {
                    paragraphs.append(paragraph)
                }
                
                return paragraphs
            }
            
            return ([firstParagraph] + paragraphs).joined(separator: "\n\n")
        }
    }

    private func generateSentence(wordCount count: Int, firstWordPair: WordPair? = nil) -> String {
        guard count > 0,
              !wordsMarkovChain.isEmpty
        else { return "" }

        
        var wordPair: WordPair
        var sentence = ""
        
        if let firstWordPair,
           wordsMarkovChain.contains(key: firstWordPair) {
            wordPair = firstWordPair
        } else {
            wordPair = wordsMarkovChain.keys.randomElement()!
        }

        for i in 0..<count {
            var (currentWord, nextWord) = (wordPair.firstWord, wordPair.secondWord)
            currentWord = i == 0 ? currentWord.capitalized : " " + currentWord

            if sentence.endsWithStrongPunctuation {
                sentence.append(currentWord.capitalized)
            } else {
                sentence.append(currentWord)
            }

            if !wordsMarkovChain.contains(key: wordPair) {
                wordPair = wordsMarkovChain.keys.randomElement()!
            }

            let randomWordAfterCurrentPair = wordsMarkovChain[wordPair]!.randomElement()!
            wordPair = WordPair(nextWord, randomWordAfterCurrentPair)
        }

        if sentence.endsWithAnyPunctuation { sentence.removeLast() }

        return sentence + "."
    }
}
