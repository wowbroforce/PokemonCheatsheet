//
//  Bootstrap.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import UIKit
import Domain

final class Bootstrap {
    static let shared = Bootstrap()
    
    private init() { }
    
    func configureMainInterface(in window: UIWindow) {
        let navigationController = UINavigationController()
        let router = PokemonListRouter(navigationController: navigationController)
        window.rootViewController = navigationController
        router.toList()
    }
}
