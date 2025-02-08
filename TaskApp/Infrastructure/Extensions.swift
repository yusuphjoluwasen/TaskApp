//
//  Extensions.swift
//  TaskApp
//
//  Created by Guru King on 08/02/2025.
//

import Foundation

///
/// extensions of optional for a string
/// returns an empty string in the absence of a value
///
extension Optional where Wrapped == String {
    var orEmpty: String {
        return self ?? ""
    }
}
