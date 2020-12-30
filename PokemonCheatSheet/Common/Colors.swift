//
//  Colors.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 12/30/20.
//

import UIKit

struct Colors {
    static var systemBackground: UIColor {
        if #available(iOS 13, *) {
            return .systemBackground
        }
        else {
            return .white
        }
    }
    
    static var label: UIColor {
        if #available(iOS 13, *) {
            return .label
        }
        else {
            return .black
        }
    }
    
    static var systemRed: UIColor {
        if #available(iOS 13, *) {
            return .systemRed
        }
        else {
            return .red
        }
    }
}
