//
//  ContentView.swift
//  Lipsumizer
//
//  Created by Diego Otero on 2024-02-08.
//

import SwiftUI
import LoremIpsumGenerator
import SwiftUIIntrospect

struct TextGenerator: View {
    
    @State private var viewModel: TextGeneratorViewModel
    
    init(viewModel: TextGeneratorViewModel = TextGeneratorViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            Group {
#if os(macOS)
                ScrollView {
                    outputTextView
                        .font(.system(.title2, design: .serif))
                        .scrollDisabled(true)
                        .padding(24)
                        .introspect(.textEditor, on: .macOS(.v14)) { nsTextView in
                            nsTextView.isEditable = false
                        }
                }
#elseif os(visionOS)
                outputTextView
                    .font(.system(.title2, design: .serif, weight: .semibold))
                    .introspect(.textEditor, on: .visionOS(.v1)) { uiTextView in
                        uiTextView.isEditable = false
                    }
#endif
            }
            .navigationTitle(viewModel.textLength.localizedDescription)
            .onAppear { viewModel.runGenerator() }
            .toolbar {
                ToolbarItem {
                    Button("Regenerate") {
                        viewModel.runGenerator()
                    }
                }
            }
        }
    }
    
    var outputTextView: some View {
        HStack {
            Spacer()
            
            TextEditor(text: .constant(viewModel.output))
                .scrollContentBackground(.hidden)
            
            Spacer()
        }
        .frame(minWidth: 256, maxWidth: 768)
    }
}

#Preview {
    TextGenerator()
}
