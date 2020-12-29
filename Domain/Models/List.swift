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
