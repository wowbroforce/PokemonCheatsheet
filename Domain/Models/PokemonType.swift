//
//  PokemonType.swift
//  Domain
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import Foundation

public struct PokemonType: Codable {
    public let slot: Int
    public let type: InternalType
}

public struct InternalType: Codable {
    public let name: String
    public let url: String
}
