//
//  ContentView.swift
//  Lipsumizer
//
//  Created by Diego Otero on 2024-02-08.
//

import SwiftUI
import LoremIpsumGenerator

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
