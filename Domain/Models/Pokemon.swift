//
//  Pokemon.swift
//  Domain
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import Foundation

public struct Pokemon: Codable {
    public let id: Int
    public let name: String
    public let sprites: Sprites
    public let stats: [Stat]
    public let types: [PokemonType]
    public let height: Int
    public let weight: Int
}
