//
//  PokemonListRouter.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import UIKit
import NetworkingService
import Domain

class PokemonListRouter {
    private let navigationController: UINavigationController
    
    private let pokemonsUseCaseProivider = NetworkingService.UseCaseProvider()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toList() {
        let pokemonsUseCase = pokemonsUseCaseProivider.makePokemonsUseCase()
        let viewModel = PokemonListViewModel(
            pokemonsUseCase: pokemonsUseCase,
            router: self
        )
        let controller = PokemonListViewController(viewModel: viewModel)
        navigationController.viewControllers = [controller]
    }
    
    func toDetails(of pokemon: Pokemon) {
        let pokemonsUseCase = pokemonsUseCaseProivider.makePokemonsUseCase()
        let router = PokemonDetailsRouter(navigationController: navigationController)
        let viewModel = PokemonDetailsViewModel(
            pokemon: pokemon,
            pokemonsUseCase: pokemonsUseCase,
            router: router
        )
        let controller = PokemonDetailsViewController(viewModel: viewModel)
        
        navigationController.pushViewController(controller, animated: true)
    }
}
