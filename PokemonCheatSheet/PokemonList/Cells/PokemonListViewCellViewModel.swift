//
//  PokemonListViewCellViewModel.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import Foundation
import Domain
import RxCocoa
import RxSwift

final class PokemonListViewCellViewModel {
    let pokemon: Pokemon
    let image: Driver<Image>
    
    private let bag = DisposeBag()
    
    init(pokemon: Pokemon, pokemonsUseCase: PokemonsUseCaseType) {
        self.pokemon = pokemon
        
        guard let url = pokemon.sprites.all.first else {
            image = .empty()
            return
        }
        
        image = pokemonsUseCase.image(for: url).asDriverOnErrorJustComplete()
    }
}
