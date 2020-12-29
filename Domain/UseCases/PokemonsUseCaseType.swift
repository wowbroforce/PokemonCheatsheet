//
//  PokemonsUseCaseType.swift
//  Domain
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import Foundation

public protocol PokemonsUseCaseType {
    func all(filter: [String: String], completion: @escaping (Result<[Pokemon], Error>) -> Void)
    func get(by id: Int, completion: @escaping (Result<Pokemon, Error>) -> Void)
}
