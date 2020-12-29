//
//  Stat.swift
//  Domain
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import Foundation

public struct Stat: Codable {
    public let baseStat: Int
    public let effort: Int
    public let stat: InternalStat
    
    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat", effort, stat
    }
}

public struct InternalStat: Codable {
    public let name: String
    public let url: String
}
