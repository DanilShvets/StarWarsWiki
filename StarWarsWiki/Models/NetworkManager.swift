//
//  NetworkManager.swift
//  StarWarsWiki
//
//  Created by Данил Швец on 03.06.2023.
//

import Foundation

protocol NetworkManagerProtocol: AnyObject {
    func parseObject(_ chosenCategory: Int, _ pageNumber: Int, _ urlCategory: String, completion: @escaping (Dictionary<String, [String]>) -> ())
}

final class NetworkManager: NetworkManagerProtocol {
    
    static let shared: NetworkManagerProtocol = NetworkManager()
    private let categories = (CharactersResponse.self, PlanetsResponse.self, ShipsResponse.self, VehiclesResponse.self, FilmsResponse.self)
    
    private init() {}
    
    func parseObject(_ chosenCategory: Int, _ pageNumber: Int, _ urlCategory: String, completion: @escaping (Dictionary<String, [String]>) -> ()) {
        
        var objectsFromResponse = Dictionary<String, [String]>()
        let urlString = "https://swapi.dev/api/\(urlCategory)/?page=\(pageNumber)"
        guard let urlRequest = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {return}
            
            do {
                switch chosenCategory {
                case 0:
                    let charactersResponse = try JSONDecoder().decode(self.categories.0, from: data)
                    charactersResponse.results.forEach { item in
                        objectsFromResponse.updateValue([item.gender, item.birth_year], forKey: item.name)
                    }
                case 1:
                    let planetsResponse = try JSONDecoder().decode(self.categories.1, from: data)
                    planetsResponse.results.forEach { item in
                        objectsFromResponse.updateValue([item.terrain, item.population], forKey: item.name)
                    }
                case 2:
                    let shipsResponse = try JSONDecoder().decode(self.categories.2, from: data)
                    shipsResponse.results.forEach { item in
                        objectsFromResponse.updateValue([item.model, item.crew], forKey: item.name)
                    }
                case 3:
                    let vehiclesResponse = try JSONDecoder().decode(self.categories.3, from: data)
                    vehiclesResponse.results.forEach { item in
                        objectsFromResponse.updateValue([item.model, item.crew], forKey: item.name)
                    }
                case 4:
                    let filmsResponse = try JSONDecoder().decode(self.categories.4, from: data)
                    filmsResponse.results.forEach { item in
                        objectsFromResponse.updateValue([item.director, item.release_date], forKey: item.title)
                    }
                default:
                    let charactersResponse = try JSONDecoder().decode(self.categories.0, from: data)
                    charactersResponse.results.forEach { item in
                        objectsFromResponse.updateValue([item.homeworld, item.birth_year], forKey: item.name)
                    }
                }
                DispatchQueue.main.async {
                    completion(objectsFromResponse)
                }
            } catch  {
                print(error)
            }
        }.resume()
    }
}
