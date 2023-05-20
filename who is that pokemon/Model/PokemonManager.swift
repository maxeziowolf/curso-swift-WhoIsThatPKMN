//
//  Pokemon Manager.swift
//  who is that pokemon
//
//  Created by Maximiliano Ovando Ramírez on 20/05/23.
//

import Foundation


struct PokemonManager {
    static let pokemonURL: String = "https://pokeapi.co/api/v2/pokemon?limit=980"
    
    func performRequest(urlString: String){
        
        //1. Se crea url
        guard let url = URL(string: PokemonManager.pokemonURL) else{
            print("No se pudo construir la url 🥲")
            return
        }
        
        //2. Se crea una URLSession
        let session = URLSession(configuration: .default)
        
        //3. Se agrega una tarea a la sessionm
        
        let task = session.dataTask(with: url){ data, response, error in
            
            if let error = error {
                print("Ocurrio el siguiente error: \(error)")
                return
            }
            
            guard let safeData = data else{
                print("Ocurrio el siguiente error al obtener la informacion")
                return
            }
            
            if let pokemon = self.parseJSON(pokemonData: safeData){
                print(pokemon)
            }
            
        }
        
        //4. Se inicia la tarea
        task.resume()
        
    }
    
    func parseJSON(pokemonData: Data) -> [PokemonModel]? {
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
