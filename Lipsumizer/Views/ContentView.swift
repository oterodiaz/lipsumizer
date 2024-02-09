//
//  ContentView.swift
//  Lipsumizer
//
//  Created by Diego Otero on 2024-02-09.
//

import SwiftUI

struct ContentView: View {
    
    private var generatorViewModel = TextGeneratorViewModel()
    
#if os(visionOS)
    @State private var currentTab: Tab = .generator
    
    private enum Tab {
        case generator, settings
    }
#endif
    
    var body: some View {
#if os(macOS)
        TextGenerator(viewModel: generatorViewModel)
#elseif os(visionOS)
        TabView(selection: $currentTab) {
            TextGenerator(viewModel: generatorViewModel)
                .tag(Tab.generator)
                .tabItem { Label("Text Generator", systemImage: "text.alignleft") }
            
            SettingsView()
                .tag(Tab.settings)
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
#endif
    }
}

#Preview {
    ContentView()
}
