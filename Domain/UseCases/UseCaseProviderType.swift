//
//  UseCaseProviderType.swift
//  Domain
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import Foundation

public protocol UseCaseProviderType {
    func makePokemonsUseCase() -> PokemonsUseCaseType
}
