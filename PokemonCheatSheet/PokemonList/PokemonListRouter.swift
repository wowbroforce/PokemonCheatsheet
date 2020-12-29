//
//  PokemonListRouter.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import UIKit
import NetworkingService

class PokemonListRouter {
    private let navigationController: UINavigationController
    
    private let pokemonsUseCaseProivider = NetworkingService.UseCaseProvider()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toList() {
        let pokemonsUseCase = pokemonsUseCaseProivider.makePokemonsUseCase()
        let viewModel = PokemonListViewModel(pokemonsUseCase: pokemonsUseCase)
        let controller = PokemonListViewController(viewModel: viewModel)
        viewModel.set(view: controller)
        navigationController.viewControllers = [controller]
    }
}
