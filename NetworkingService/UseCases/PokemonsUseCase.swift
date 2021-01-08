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
    
    func all(limit: Int? = nil, offset: Int? = nil) -> Observable<List<PokemonListItem>> {
        let params = cacheParams(limit: limit, offset: offset)
        let cachedItems: Observable<List<PokemonListItem>> = cache.fetch(params: params).asObservable()
        let items = api.all(limit: limit, offset: offset)
            .flatMap {
                self.cache
                    .save(object: $0, params: params)
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

    func next(url: String) -> Observable<List<PokemonListItem>> {
        guard
            let url = URL(string: url),
            let params = url.queryParameters,
            let limit = Int(params["limit"] ?? ""),
            let offset = Int(params["offset"] ?? "")
        else {
            return .error(Errors.cantGetQueryParameters)
        }
        
        return all(limit: limit, offset: offset)
    }
    
    private func cacheParams(limit: Int?, offset: Int?) -> [String: Any] {
        var params: [String: Any] = [:]
        params["offset"] = offset
        params["limit"] = limit
        return params
    }
        
    enum Errors: Error {
        case cantGetQueryParameters
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

extension URL {
    public var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
}
