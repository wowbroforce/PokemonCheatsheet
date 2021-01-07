//
//  Fetcher.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 1/7/21.
//

import Foundation
import RxSwift
import RxCocoa
import Domain

protocol Fetcher {
    associatedtype Element: Codable
    
    func list() -> Driver<List<Element>>
    func start() -> Driver<Void>
    func next() -> Driver<Void>
    func fetching() -> Driver<Bool>
    func errors() -> Driver<Error>
}
