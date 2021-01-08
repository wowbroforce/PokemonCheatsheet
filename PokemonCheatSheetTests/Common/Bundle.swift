//
//  Bundle.swift
//  PokemonCheatSheetTests
//
//  Created by Prokhor Kharchenko on 1/8/21.
//

import Foundation

private final class TestBundleIdentifier { }

extension Bundle {
    static let test = Bundle(for: TestBundleIdentifier.self)
}
