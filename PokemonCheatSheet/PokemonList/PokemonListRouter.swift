//
//  PokemonListRouter.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import UIKit

class PokemonListRouter {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toList() {
        let viewModel = PokemonListViewModel()
        let controller = PokemonListViewController(viewModel: viewModel)
        navigationController.viewControllers = [controller]
    }
}
