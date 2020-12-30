//
//  String+Extensions.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 12/30/20.
//

import Foundation

extension String {
    var emojified: String {
        switch self.lowercased() {
        case "normal":
            return "⭐️"
        case "fighting":
            return "✊"
        case "flying":
            return "🦅"
        case "poison":
            return "🧪"
        case "ground":
            return "⛰"
        case "rock":
            return "🤘"
        case "bug":
            return "🐞"
        case "ghost":
            return "👻"
        case "steel":
            return "🛡"
        case "fire":
            return "🔥"
        case "water":
            return "💦"
        case "grass":
            return "🌿"
        case "electric":
            return "⚡️"
        case "psychic":
            return "👁"
        case "ice":
            return "🧊"
        case "dragon":
            return "🐉"
        case "dark":
            return "💀"
        case "fairy":
            return "🧚‍♀️"
        case "unknown":
            return "❓"
        case "shadow":
            return "👤"
        default:
            return "❓"
        }
    }
}
