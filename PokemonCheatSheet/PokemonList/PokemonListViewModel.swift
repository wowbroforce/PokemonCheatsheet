//
//  PokemonListViewModel.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import Domain

protocol PokemonListViewModelType {
    var pokemons: [Pokemon] { get }
    var error: Error? { get }
    var fetching: Bool { get }

    func fetch()
    func pokemonSelected(at indetPath: IndexPath)
}

final class PokemonListViewModel: PokemonListViewModelType {
    var pokemons: [Pokemon] = []
    var error: Error?
    var fetching: Bool = false
    
    private weak var view: ViewUpdatable?
    private let pokemonsUseCase: PokemonsUseCaseType
    
    init(pokemonsUseCase: PokemonsUseCaseType) {
        self.pokemonsUseCase = pokemonsUseCase
    }

    func set(view: ViewUpdatable) {
        self.view = view
    }

    func fetch() {
        fetching = true
        view?.update()
        
        pokemonsUseCase.all(filter: [:]) { [weak self] result in
            guard let self = self else { return }
            
            self.fetching = false
            
            switch result {
            case .success(let pokemons):
                self.pokemons = pokemons
                self.error = nil
            case .failure(let error):
                self.error = error
            }
            
            self.view?.update()
        }
    }
    
    func pokemonSelected(at indetPath: IndexPath) {
        
    }
}
