//
//  PokemonsUseCase.swift
//  NetworkingService
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import Foundation
import Domain
import RxSwift

final class PokemonsUseCase: PokemonsUseCaseType {
    private let api: PokemonsAPI
    private let cache: Cache
    
    init(
        api: PokemonsAPI,
        cache: Cache
    ) {
        self.api = api
        self.cache = cache
    }
    
    func all() -> Observable<List<PokemonListItem>> {
        let cachedItems: Observable<List<PokemonListItem>> = cache.fetch().asObservable()
        let items = api.all()
            .flatMap {
                self.cache
                    .save(object: $0)
                    .asObservable()
                    .map(to: List<PokemonListItem>.self)
                    .concat(Observable.just($0))
            }
        return cachedItems.concat(items)
    }
    
    func get(by name: String) -> Observable<Pokemon> {
        let cachedItem: Observable<Pokemon> = cache.fetch(by: name).asObservable()
        let item = api.get(by: name)
            .flatMap {
                self.cache
                    .save(object: $0)
                    .asObservable()
                    .map(to: Pokemon.self)
                    .concat(Observable.just($0))
            }
        return cachedItem.concat(item)
    }
    
    func image(url: String) -> Observable<Image> {
        let cachedImage = cache.fetchImage(by: url).asObservable()
        let image = api.image(url: url)
            .flatMap {
                self.cache
                    .save(image: $0, path: url)
                    .asObservable()
                    .map(to: Image.self)
                    .concat(Observable.just($0))
            }
        return cachedImage.concat(image)
    }
    
    private func stub(_ string: String) -> Pokemon {
        let decoder = JSONDecoder()
        let data = string.data(using: .utf8)!
        return try! decoder.decode(Pokemon.self, from: data)
    }
}

struct MapFromNever: Error {}
extension ObservableType where Element == Never {
    func map<T>(to: T.Type) -> Observable<T> {
        return self.flatMap { _ in
            return Observable<T>.error(MapFromNever())
        }
    }
}
