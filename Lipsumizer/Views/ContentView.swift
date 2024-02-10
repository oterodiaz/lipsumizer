//
//  ContentView.swift
//  Lipsumizer
//
//  Created by Diego Otero on 2024-02-09.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(AppState.self) private var appState
    
#if os(visionOS)
    @State private var currentTab: Tab = .generator
    
    private enum Tab {
        case generator, settings
    }
#endif
    
    var body: some View {
#if os(macOS)
        TextGenerator(viewModel: appState.textGeneratorViewModel)
#elseif os(visionOS)
        TabView(selection: $currentTab) {
            TextGenerator(viewModel: appState.textGeneratorViewModel)
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
