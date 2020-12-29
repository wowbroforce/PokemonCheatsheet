//
//  CellReusable.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import UIKit

protocol CellReusable {
    static var reuseIdentifier: String { get }
}

extension UITableViewCell: CellReusable {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
