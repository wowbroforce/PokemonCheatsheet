//
//  Pokemon+Cacheable.swift
//  NetworkingService
//
//  Created by Prokhor Kharchenko on 12/30/20.
//

import Domain

extension Pokemon: Cacheable {
    var cacheIdintifier: String {
        name
    }
}
