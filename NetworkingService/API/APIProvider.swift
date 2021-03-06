//
//  APIProvider.swift
//  NetworkingService
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import Foundation
import Domain

final class APIProvider {
    private let apiEndpoint: String
    
    init() {
        apiEndpoint = "https://pokeapi.co/api/v2"
    }
    
    func makePokemonsAPI() -> PokemonsAPI {
        let service = NetworkingService(endpoint: apiEndpoint)
        return PokemonsAPI(service: service)
    }
}
