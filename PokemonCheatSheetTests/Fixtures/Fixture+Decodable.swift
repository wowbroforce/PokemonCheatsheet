//
//  Fixture+Decodable.swift
//  PokemonCheatSheetTests
//
//  Created by Prokhor Kharchenko on 1/8/21.
//

import Foundation

extension Decodable {
    static func load(from fileName: String) -> Self {
        guard let pathString = Bundle.test.path(forResource: fileName, ofType: "json") else {
            fatalError("\(fileName).json not found")
        }
        
        guard let jsonString = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Can't convert \(fileName).json to String")
        }
        
        guard let data = jsonString.data(using: .utf8) else {
            fatalError("Can't convert \(fileName).json to Data")
        }
 
        guard let element = try? JSONDecoder().decode(self, from: data) else {
            fatalError("Can't decode the Data to \(self.self)")
        }
        
        return element
    }
}
