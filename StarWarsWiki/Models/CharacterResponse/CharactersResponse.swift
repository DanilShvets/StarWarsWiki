//
//  CharactersResponse.swift
//  StarWarsWiki
//
//  Created by Данил Швец on 09.04.2023.
//

import Foundation

struct CharactersResponse: Codable {
    
    let count: Int
    let results: [CharacterModel]
    
}
