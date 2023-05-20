//
//  PokemonData.swift
//  who is that pokemon
//
//  Created by Maximiliano Ovando Ramírez on 20/05/23.
//

import Foundation


// MARK: - PokemonData
struct PokemonData: Codable {
    let results: [Result]?
}

// MARK: - Result
struct Result: Codable {
    let name: String?
    let url: String?
}
