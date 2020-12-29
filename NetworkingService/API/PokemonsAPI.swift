//
//  PokemonsAPI.swift
//  NetworkingService
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import Foundation
import Domain
import RxSwift

public final class PokemonsAPI {
    let service: NetworkingService
    
    init(service: NetworkingService) {
        self.service = service
    }
    
    public func all() -> Observable<List<PokemonListItem>> {
        service.getItems(path: "pokemon")
    }
    
    public func get(by name: String) -> Observable<Pokemon> {
        service.getItem(path: "pokemon", name: name)
    }
    
    public func image(for pokemon: Pokemon) -> Observable<Image?> {
        guard let url = pokemon.sprites.all.first else {
            return .just(nil)
        }
        return service.getImage(url: url)
    }

    public func images(for pokemon: Pokemon) -> Observable<[Image]> {
        let images = pokemon
            .sprites
            .all
            .map {
                service.getImage(url: $0)
            }
        
        return Observable
            .zip(images)
            .map { $0.compactMap { $0 } }
    }
}
