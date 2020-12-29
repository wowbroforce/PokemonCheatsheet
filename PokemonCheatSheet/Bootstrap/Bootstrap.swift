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
        configureDefaultAppearance()
        
        let navigationController = BaseNavigationController()
        let router = PokemonListRouter(navigationController: navigationController)
        window.rootViewController = navigationController
        router.toList()
    }
    
    private func configureDefaultAppearance() {
//        UINavigationBar.appearance().isTranslucent = false
//        UITableView.appearance().backgroundColor = .white
//        UIView.appearance(whenContainedInInstancesOf: [UIViewController.self]).backgroundColor = .green
    }
}
