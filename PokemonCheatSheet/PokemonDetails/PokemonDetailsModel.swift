//
//  PokemonDetailsModel.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import Foundation
import Domain

struct PokemonDetailsModel {
    let name: String
    let weight: Int
    let height: Int
    let types: [String]
    let stats: [(String, String)]
    let images: [Image]
}
