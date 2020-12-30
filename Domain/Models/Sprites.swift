//
//  Sprites.swift
//  Domain
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import Foundation

public struct Sprites: Codable {
    public let frontDefault: String?
    public let frontShiny: String?
    public let frontFemale: String?
    public let frontShinyFemale: String?
    public let backDefault: String?
    public let backShiny: String?
    public let backFemale: String?
    public let backShinyFemale: String?
    
    public var all: [String] {
        return [
            frontDefault, backDefault, frontShiny, backShiny,
            frontFemale, backFemale, frontShinyFemale, backShinyFemale
        ].compactMap { $0 }
    }

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default",
             frontShiny = "front_shiny",
             frontFemale = "front_female",
             frontShinyFemale = "front_shiny_female",
             backDefault = "back_default",
             backShiny = "back_shiny",
             backFemale = "back_female",
             backShinyFemale = "back_shiny_female"
    }
}
