//
//  UseCaseProvider.swift
//  NetworkingService
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import Foundation
import Domain

public final class UseCaseProvider: UseCaseProviderType {
    public init() {
        
    }

    public func makePokemonsUseCase() -> PokemonsUseCaseType {
        PokemonsUseCase()
    }
}
