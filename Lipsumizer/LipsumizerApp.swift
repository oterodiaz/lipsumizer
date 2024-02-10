//
//  LipsumizerApp.swift
//  Lipsumizer
//
//  Created by Diego Otero on 2024-02-08.
//

import SwiftUI

@main
struct LipsumizerApp: App {
    
    @State private var appState: AppState
    
    init() {
        let customTextURL = Bundle.main.url(forResource: "don-quixote", withExtension: "txt")!
        let customText = try! String(contentsOf: customTextURL)
        
        UserDefaults.standard.register(
            defaults: [
                UserDefaultsKey.beginWithLoremIpsum.string: true,
                UserDefaultsKey.genWordsOnLaunch.string: false,
                UserDefaultsKey.initialParagraphCount.string: 5,
                UserDefaultsKey.initialWordCount.string: 70,
                UserDefaultsKey.genFromCustomText.string: false,
                UserDefaultsKey.customText.string: customText
            ]
        )
        
        self.appState = AppState()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(idealWidth: 512, minHeight: 256, idealHeight: 512)
                .environment(appState)
        }
#if os(macOS)
        .defaultSize(width: 550, height: 500)
#elseif os(visionOS)
        .defaultSize(width: 750, height: 700)
#endif
        
#if os(macOS)
        Settings {
            SettingsView()
                .environment(appState)
        }
#endif
    }
}
