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
    let item: PokemonListItem
    let image: Driver<Image>
    
    private let bag = DisposeBag()
    
    init(
        item: PokemonListItem,
        pokemonsUseCase: PokemonsUseCaseType,
        placeholderImage: Image
    ) {
        self.item = item

        image = pokemonsUseCase
            .get(by: item.name)
            .map { $0.sprites.all.first }
            .flatMapLatest { url -> Observable<Image> in
                guard let url = url else {
                    return .just(placeholderImage)
                }
                return pokemonsUseCase.image(url: url)
            }
            .asDriverOnErrorJustComplete()
    }
}
