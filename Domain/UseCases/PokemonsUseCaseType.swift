//
//  PokemonsUseCaseType.swift
//  Domain
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import Foundation
import RxSwift

public protocol PokemonsUseCaseType {
    func all(limit: Int?, offset: Int?) -> Observable<List<PokemonListItem>>
    func get(by name: String) -> Observable<Pokemon>
    func image(url: String) -> Observable<Image>
    func next(url: String) -> Observable<List<PokemonListItem>>
}
