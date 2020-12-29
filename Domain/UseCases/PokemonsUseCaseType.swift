//
//  PokemonsUseCaseType.swift
//  Domain
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import Foundation
import RxSwift

public protocol PokemonsUseCaseType {
    func all() -> Observable<List<PokemonListItem>>
    func get(by name: String) -> Observable<Pokemon>
    func image(for pokemon: Pokemon) -> Observable<Image?>
    func images(for pokemon: Pokemon) -> Observable<[Image]>
}
