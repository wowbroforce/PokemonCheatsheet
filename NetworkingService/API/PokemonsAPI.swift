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
    
    public func all(limit: Int? = nil, offset: Int? = nil) -> Observable<List<PokemonListItem>> {
        var params: [String: Any] = [:]
        params["limit"] = limit
        params["offset"] = offset

        return service.getItems(path: "pokemon", params: params)
    }
    
    public func get(by name: String) -> Observable<Pokemon> {
        service.getItem(path: "pokemon", name: name)
    }
    
    public func image(url: String) -> Observable<Image> {
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
