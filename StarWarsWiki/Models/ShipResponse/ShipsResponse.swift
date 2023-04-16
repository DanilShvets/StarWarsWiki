//
//  ShipResponse.swift
//  StarWarsWiki
//
//  Created by Данил Швец on 15.04.2023.
//

import Foundation

struct ShipsResponse: Codable {
    
    let count: Int
    let results: [ShipModel]
    
}
