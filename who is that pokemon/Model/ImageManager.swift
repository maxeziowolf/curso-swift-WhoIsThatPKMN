//
//  ImageManager.swift
//  who is that pokemon
//
//  Created by Maximiliano Ovando Ramírez on 20/05/23.
//

import Foundation

protocol ImageManagerDelegate {
    func didUpdateImage(imageModel: ImageModel)
    func didFailWithError(error: Error)
}

struct ImageManager {
    public static var delegate: ImageManagerDelegate?
    
    static func fetchPokemon(urlString: String){
        performRequest(urlString: urlString)
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
            
            if let image = self.parseJSON(pokemonData: safeData){
                self.delegate?.didUpdateImage(imageModel: image)
            }else{
                self.delegate?.didFailWithError(error: NSError(domain: "No se obtuvo informacion", code: -99))
            }
            
            
            
        }
        
        //4. Se inicia la tarea
        task.resume()
        
    }
    
    private static func parseJSON(pokemonData: Data) -> ImageModel? {
        let decoder = JSONDecoder()
        
        do{
            let decodeData = try decoder.decode(ImageData.self, from: pokemonData)
            
            if let name = decodeData.name, let imageURL = decodeData.sprites?.other?.officialArtwork?.frontDefault {
                return ImageModel(name: name, imageURL: imageURL)
            }
            
            return nil
            
        }catch{
            
            return nil
            
        }
    }
    
}
