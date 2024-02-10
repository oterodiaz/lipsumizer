//
//  SettingsView.swift
//  Lipsumizer
//
//  Created by Diego Otero on 2024-02-09.
//

import SwiftUI
import LoremIpsumGenerator

struct SettingsView: View {
    
    @Environment(AppState.self) private var appState
    @State private var isShowingResetConfirmationAlert = false
    
    @AppStorage(UserDefaultsKey.beginWithLoremIpsum.string) private var beginWithLoremIpsum = true
    @AppStorage(UserDefaultsKey.genWordsOnLaunch.string) private var genWordsOnLaunch = false
    @AppStorage(UserDefaultsKey.initialParagraphCount.string) private var initialParagraphCount = 3
    @AppStorage(UserDefaultsKey.initialWordCount.string) private var initialWordCount = 70
    
    var beginWithLoremIpsumBinding: Binding<Bool> {
        Binding(
            get: { beginWithLoremIpsum },
            set: {
                beginWithLoremIpsum = $0
                appState.textGeneratorViewModel.beginWithLoremIpsum = $0
            }
        )
    }
    
    var unitPickerBinding: Binding<TextLength.LengthUnit> {
        Binding(
            get: { genWordsOnLaunch ? .word : .paragraph },
            set: {
                genWordsOnLaunch = ($0 == .word)
                
                appState.textGeneratorViewModel.textLength.unit = $0
                if genWordsOnLaunch {
                    appState.textGeneratorViewModel.setTextLengthCount(initialWordCount)
                } else {
                    appState.textGeneratorViewModel.setTextLengthCount(initialParagraphCount)
                }
            }
        )
    }
    
    var defaultTextLengthBinding: Binding<Int> {
        Binding(
            get: { genWordsOnLaunch ? initialWordCount : initialParagraphCount },
            set: {
                if genWordsOnLaunch {
                    initialWordCount = min(10_000, max(1, $0))
                } else {
                    initialParagraphCount = min(1_000, max(1, $0))
                }
                
                appState.textGeneratorViewModel.setTextLengthCount($0)
            }
        )
    }
    
    var body: some View {
        @Bindable var generator = appState.textGeneratorViewModel
        
        NavigationStack {
            Form {
                Section("Text Generator") {
                    Toggle("Begin with *Lorem ipsum...*", isOn: beginWithLoremIpsumBinding)
                        .disabled(generator.generator.isUsingCustomText)
                    
                    Picker("Default text length unit", selection: unitPickerBinding) {
                        Text("Paragraphs")
                            .tag(TextLength.LengthUnit.paragraph)
                        
                        Text("Words")
                            .tag(TextLength.LengthUnit.word)
                    }
                    
                    HStack {
                        Text("Default text length")
                        
                        Spacer()
                        
                        TextField("Default text length", value: defaultTextLengthBinding, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.center)
#if os(visionOS)
                            .frame(width: 100)
#endif
                            .fixedSize()
                            .labelsHidden()
                        
                        Stepper("Default text length", value: defaultTextLengthBinding)
                            .labelsHidden()
                    }
                    
                }
                
                Section("Custom Text") {
                    Toggle("Generate from custom text", isOn: .constant(false))
                    Button("Choose file(s)") { }
                }
                
#if os(visionOS)
                resetButton
#endif
            }
            .formStyle(.grouped)
            .navigationTitle("Settings")
            .alert("Reset app settings", isPresented: $isShowingResetConfirmationAlert) {
                Button("Yes", role: .destructive) {
                    UserDefaults.standard.reset()
                    generator.beginWithLoremIpsum = true
                    generator.textLength = .init(unit: genWordsOnLaunch ? .word : .paragraph, count: genWordsOnLaunch ? initialWordCount : initialParagraphCount)
                }
                
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to restore the default settings?")
            }
#if os(macOS)
            .frame(width: 500, height: 370)
            .overlay {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        resetButton
                    }
                }
                .padding()
            }
#endif
        }
    }
    
    var resetButton: some View {
        Button("Reset settings", role: .destructive) {
            isShowingResetConfirmationAlert = true
        }
    }
}


#Preview {
    SettingsView()
        .environment(AppState())
}
