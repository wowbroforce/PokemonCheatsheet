//
//  PokemonsUseCaseType.swift
//  Domain
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import Foundation
import RxSwift

public protocol PokemonsUseCaseType {
    func all(filter: [String: String]) -> Observable<[Pokemon]>
    func get(by id: Int) -> Observable<Pokemon>
    func image(for url: String) -> Observable<Image>
}
