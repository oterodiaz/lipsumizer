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
    
    @State private var isShowingCustomTextSheet = false
    @State private var isShowingResetConfirmationAlert = false
    
    @FocusState private var isTextFieldFocused: Bool
    
    @AppStorage(UserDefaultsKey.beginWithLoremIpsum.string) private var beginWithLoremIpsum = true
    @AppStorage(UserDefaultsKey.genWordsOnLaunch.string) private var genWordsOnLaunch = false
    @AppStorage(UserDefaultsKey.initialParagraphCount.string) private var initialParagraphCount = 5
    @AppStorage(UserDefaultsKey.initialWordCount.string) private var initialWordCount = 70
    @AppStorage(UserDefaultsKey.genFromCustomText.string) private var genFromCustomText = false
    @AppStorage(UserDefaultsKey.customText.string) private var customText = "Placeholder"
    
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
                            .focused($isTextFieldFocused)
                            .onSubmit { isTextFieldFocused = false }
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
                    HStack {
                        Text("Generate from custom text")
                        
                        Spacer()
                        
                        Button() {
                            isShowingCustomTextSheet = true
                        } label: {
                            Label("Edit custom text", systemImage: "pencil")
                                .labelStyle(.iconOnly)
                        }
                        .buttonStyle(.borderless)

                        Toggle("Generate from custom text", isOn: genFromCustomTextBinding)
                            .labelsHidden()
                    }
                }
            }
            
            .formStyle(.grouped)
            .onTapGesture { isTextFieldFocused = false }
            .navigationTitle("Settings")
            .sheet(isPresented: $isShowingCustomTextSheet) { customTextSheetContent }
            .alert("Reset app settings", isPresented: $isShowingResetConfirmationAlert) {
                Button("Yes", role: .destructive) {
                    UserDefaults.standard.reset()
                    generator.beginWithLoremIpsum = true
                    generator.textLength = .init(unit: genWordsOnLaunch ? .word : .paragraph, count: genWordsOnLaunch ? initialWordCount : initialParagraphCount)
                    generator.generator = LoremIpsumGenerator()
                }
                
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to restore the default settings?")
            }
#if os(macOS)
            .frame(width: 500, height: 310)
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
#elseif os(visionOS)
            .toolbar {
                ToolbarItem {
                    resetButton
                }
            }
#endif
        }
    }
    
    var customTextSheetContent: some View {
#if os(macOS)
        NavigationStack {
            VStack {
                TextEditor(text: customTextBinding)
                HStack {
                    Button("Clear text", role: .destructive) {
                        customText = ""
                        
                        if genFromCustomText {
                            appState.textGeneratorViewModel.generator = LoremIpsumGenerator(fromCustomText: customText)
                            appState.textGeneratorViewModel.runGenerator()
                        }
                    }
                    
                    Button("Restore sample text") {
                        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.customText.string)
                        
                        if genFromCustomText {
                            appState.textGeneratorViewModel.generator = LoremIpsumGenerator(fromCustomText: UserDefaults.standard.string(forKey: UserDefaultsKey.customText.string)!)
                            appState.textGeneratorViewModel.runGenerator()
                        }
                    }
                    
                    Spacer()
                    
                    Button("Done") {
                        isShowingCustomTextSheet = false
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Edit Custom Text")
            .padding()
        }
        .frame(width: 384, height: 256)
#elseif os(visionOS)
            NavigationStack {
            TextEditor(text: customTextBinding)
                .navigationTitle("Edit Custom Text")
                .toolbar {
                    ToolbarItemGroup(placement: .primaryAction) {
                        Button(role: .destructive) {
                            customText = ""
                            
                            if genFromCustomText {
                                appState.textGeneratorViewModel.generator = LoremIpsumGenerator(fromCustomText: customText)
                                appState.textGeneratorViewModel.runGenerator()
                            }
                        } label: {
                            Label("Clear text", systemImage: "eraser")
                        }
                        .help("Clear text")
                        
                        Button {
                            UserDefaults.standard.removeObject(forKey: UserDefaultsKey.customText.string)
                            
                            if genFromCustomText {
                                appState.textGeneratorViewModel.generator = LoremIpsumGenerator(fromCustomText: UserDefaults.standard.string(forKey: UserDefaultsKey.customText.string)!)
                                appState.textGeneratorViewModel.runGenerator()
                            }
                        } label: {
                            Label("Restore sample text", systemImage: "arrow.counterclockwise")
                        }
                        .help("Restore sample text")
                        
                        Button("Done") {
                            isShowingCustomTextSheet = false
                        }
                    }
                }
            }
            .frame(width: 600, height: 550)
#endif
    }
    
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
    
    var customTextBinding: Binding<String> {
        Binding(
            get: { customText },
            set: {
                customText = $0
                
                if genFromCustomText {
                    appState.textGeneratorViewModel.generator = LoremIpsumGenerator(fromCustomText: $0)
                    appState.textGeneratorViewModel.runGenerator()
                }
            }
        )
    }
    
    var genFromCustomTextBinding: Binding<Bool> {
        Binding(
            get: { genFromCustomText },
            set: {
                genFromCustomText = $0
                
                if genFromCustomText {
                    appState.textGeneratorViewModel.generator = LoremIpsumGenerator(fromCustomText: customText)
                } else {
                    appState.textGeneratorViewModel.generator = LoremIpsumGenerator()
                }
            }
        )
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
