//
//  +UserDefaults.swift
//  Lipsumizer
//
//  Created by Diego Otero on 2024-02-10.
//

import Foundation

extension UserDefaults {
    func reset() {
        UserDefaultsKey.allCases.forEach { removeObject(forKey: $0.string) }
    }
}
