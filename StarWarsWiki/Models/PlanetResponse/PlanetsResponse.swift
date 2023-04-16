//
//  PlanetsResponse.swift
//  StarWarsWiki
//
//  Created by Данил Швец on 11.04.2023.
//

import Foundation

struct PlanetsResponse: Codable {
    
    let count: Int
    let results: [PlanetModel]
    
}
