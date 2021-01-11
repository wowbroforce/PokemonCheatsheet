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
    private weak var navigationController: UINavigationController?
    
    private let pokemonsUseCaseProivider = NetworkingService.UseCaseProvider()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toList() {
        guard let navigationController = navigationController else { return }
        let pokemonsUseCase = pokemonsUseCaseProivider.makePokemonsUseCase()
        let fetcher = PaginatedFetcher(limit: 50, useCase: pokemonsUseCase).toAny()
        let viewModel = PokemonListViewModel(
            pokemonsUseCase: pokemonsUseCase,
            router: self,
            fetcher: fetcher
        )
        let view = PokemonListView()
        let controller = PokemonListViewController(view: view, viewModel: viewModel)
        navigationController.viewControllers = [controller]
    }
    
    func toDetails(of item: PokemonListItem) {
        guard let navigationController = navigationController else { return }
        let pokemonsUseCase = pokemonsUseCaseProivider.makePokemonsUseCase()
        let router = PokemonDetailsRouter(navigationController: navigationController)
        let viewModel = PokemonDetailsViewModel(
            item: item,
            pokemonsUseCase: pokemonsUseCase,
            router: router
        )
        let view = PokemonDetailsView()
        let controller = PokemonDetailsViewController(
            pokemonDetailsView: view,
            viewModel: viewModel
        )
        
        navigationController.pushViewController(controller, animated: true)
    }
}
