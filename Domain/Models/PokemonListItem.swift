//
//  PokemonListItem.swift
//  Domain
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import Foundation

//public struct PokemonList: Codable {
//    public let count: Int
//    public let next: String
//    public let previous: String
//    public let results: [PokemonListItem]
//}

public struct PokemonListItem: Codable {
    public let name: String
    public let url: String
}
