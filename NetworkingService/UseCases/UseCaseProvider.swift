//
//  UseCaseProvider.swift
//  NetworkingService
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import Foundation
import Domain

public final class UseCaseProvider: UseCaseProviderType {
    private let apiProvider: APIProvider
    
    public init() {
        apiProvider = APIProvider()
    }

    public func makePokemonsUseCase() -> PokemonsUseCaseType {
        let api = apiProvider.makePokemonsAPI()
        return PokemonsUseCase(api: api)
    }
}
