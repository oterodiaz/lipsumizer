//
//  LipsumizerApp.swift
//  Lipsumizer
//
//  Created by Diego Otero on 2024-02-08.
//

import SwiftUI

@main
struct LipsumizerApp: App {
    var body: some Scene {
        WindowGroup {
            TextGenerator()
                .frame(idealWidth: 512, minHeight: 256, idealHeight: 512)
        }
        .windowResizability(.contentSize)
    }
}
