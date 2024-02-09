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
            ScrollView {
                outputTextView
            }
            .navigationTitle(viewModel.navigationTitle)
            .onAppear { viewModel.runGenerator() }
            .onChange(of: viewModel.textLength) { viewModel.runGenerator() }
            .animation(.easeIn, value: viewModel.textLength)
            .toolbar {
                toolbarItems
            }
        }
    }
    
    var outputTextView: some View {
        HStack {
            Spacer()
            
            TextEditor(text: .constant(viewModel.output))
                .scrollContentBackground(.hidden)
#if os(macOS)
                .font(.system(.title2, design: .serif))
                .scrollDisabled(true)
                .introspect(.textEditor, on: .macOS(.v14)) { nsTextView in
                    nsTextView.isEditable = false
                }
#elseif os(visionOS)
                .font(.system(.title2, design: .serif, weight: .semibold))
                .introspect(.textEditor, on: .visionOS(.v1)) { uiTextView in
                    uiTextView.isEditable = false
                }
#endif
            
            Spacer()
        }
        .frame(minWidth: 256, maxWidth: 768)
#if os(macOS)
        .padding(24)
#elseif os(visionOS)
        .padding([.horizontal, .bottom])
#endif
    }
        
    @ToolbarContentBuilder
    var toolbarItems: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Button {
                viewModel.toggleLengthUnit()
            } label: {
                Label("Toggle text length unit", systemImage: "arrow.left.arrow.right")
            }
            .help("Toggle text length unit")
            
            Button {
                viewModel.runGenerator()
            } label: {
                Label("Generate new text", systemImage: "arrow.clockwise")
            }
            .help("Generate new text")
            
            Button {
#if os(macOS)
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(viewModel.output, forType: .string)
#elseif os(visionOS)
                let pasteboard = UIPasteboard.general
                pasteboard.string = viewModel.output
#endif
            } label: {
                Label("Copy text", systemImage: "doc.on.doc")
            }
            .help("Copy text")
            
#if os(macOS)
            textLengthControls
#endif
        }
        
#if os(visionOS)
        ToolbarItemGroup(placement: .bottomOrnament) {
            textLengthControls
        }
#endif
    }
        
    @ViewBuilder
    var textLengthControls: some View {
        Button {
            viewModel.decreaseTextLength()
        } label: {
            Label("Decrease text length", systemImage: "minus")
        }
        .help("Decrease text length")
        
        TextField("Text length", value: $viewModel.textLength.count, format: .number)
            .multilineTextAlignment(.center)
            .help("Text length")
#if os(visionOS)
            .frame(maxWidth: 48)
#endif

        Button {
            viewModel.increaseTextLength()
        } label: {
            Label("Increase text length", systemImage: "plus")
        }
        .help("Increase text length")
    }
}

#Preview {
    TextGenerator()
}
