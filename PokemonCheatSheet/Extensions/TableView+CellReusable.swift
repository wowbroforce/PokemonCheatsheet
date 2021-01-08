//
//  TableView+CellReusable.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 1/8/21.
//

import Foundation
import UIKit

extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("Can't dequeue reusable cell of type \(T.self)")
        }
        return cell
    }
}
