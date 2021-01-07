//
//  List.swift
//  Domain
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import Foundation

public struct List<Model: Codable>: Codable {
    public let count: Int
    public let next: String?
    public let previous: String?
    public let results: [Model]
}

public extension List {
    static var empty: Self {
        List(
            count: 0,
            next: nil,
            previous: nil,
            results: []
        )
    }
    
    func merged(with list: Self) -> Self {
        List(
            count: list.count,
            next: list.next,
            previous: nil,
            results: results + list.results
        )
    }
}
