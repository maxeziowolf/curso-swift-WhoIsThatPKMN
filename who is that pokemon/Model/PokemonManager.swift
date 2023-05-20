//
//  Pokemon Manager.swift
//  who is that pokemon
//
//  Created by Maximiliano Ovando Ramírez on 20/05/23.
//

import Foundation

protocol PokemonManagerDelegate {
    func didUpdatePokemon(pokemon: [PokemonModel])
    func didFailWithError(error: Error)
}

struct PokemonManager {
    private static let pokemonURL: String = "https://pokeapi.co/api/v2/pokemon?limit=980"
    public static var delegate: PokemonManagerDelegate?
    
    static func fetchPokemon(){
        performRequest(urlString: PokemonManager.pokemonURL)
    }
    
    private static func performRequest(urlString: String){
        
        //1. Se crea url
        guard let url = URL(string: urlString) else{
            print("No se pudo construir la url 🥲")
            return
        }
        
        //2. Se crea una URLSession
        let session = URLSession(configuration: .default)
        
        //3. Se agrega una tarea a la sessionm
        
        let task = session.dataTask(with: url){ data, response, error in
            
            if let error = error {
                print("Ocurrio el siguiente error: \(error)")
                self.delegate?.didFailWithError(error: error)
                return
            }
            
            guard let safeData = data else{
                print("Ocurrio el siguiente error al obtener la informacion")
                self.delegate?.didFailWithError(error: NSError(domain: "No se obtuvo informacion", code: -99))
                return
            }
            
            if let pokemon = self.parseJSON(pokemonData: safeData){
                self.delegate?.didUpdatePokemon(pokemon: pokemon)
            }else{
                self.delegate?.didFailWithError(error: NSError(domain: "No se obtuvo informacion", code: -99))
            }
            
           
            
        }
        
        //4. Se inicia la tarea
        task.resume()
        
    }
    
    private static func parseJSON(pokemonData: Data) -> [PokemonModel]? {
        let decoder = JSONDecoder()
        
        do{
            let decodeData = try decoder.decode(PokemonData.self, from: pokemonData)
            
            let pokemon = decodeData.results?.compactMap({
                if let name = $0.name, let imageURL = $0.url {
                    return PokemonModel(name: name, imageURL: imageURL)
                }
                return nil 
            })
            
            return pokemon
            
        }catch{
            
            return nil
            
        }
    }
    
}
