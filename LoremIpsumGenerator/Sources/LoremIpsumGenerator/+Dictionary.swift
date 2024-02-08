//
//  +Dictionary.swift
//
//
//  Created by Diego Otero on 2024-02-08.
//

import Foundation

extension Dictionary {
    func contains(key: Key) -> Bool {
        self[key] != nil
    }
}
