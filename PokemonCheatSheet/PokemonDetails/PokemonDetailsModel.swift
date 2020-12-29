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
    let types: [String]
    let stats: [String]
    let images: [Image]
}
