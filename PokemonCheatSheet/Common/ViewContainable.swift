//
//  ViewContainable.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 1/11/21.
//

import Foundation
import UIKit

protocol ViewContainable: AnyObject {
    var view: UIView! { get }
}

extension UIViewController: ViewContainable { }
extension UIView: ViewContainable {
    var view: UIView! { self }
}

