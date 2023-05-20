//
//  ViewController.swift
//  who is that pokemon
//
//  Created by Alex Camacho on 01/08/22.
//

import UIKit

class PokemonViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet var answerButtons: [UIButton]!
    
    //MARK: Variables
    var pokemon: [PokemonModel] = []
    var correctAnswer: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegates()
        PokemonManager.fetchPokemon()
    }
    
    private func setupUI(){
        
        //Configuracion de botones
        for buttom in answerButtons {
            buttom.layer.cornerRadius = 10
            buttom.layer.masksToBounds = false
        }
        
    }
    
    private func setupDelegates(){
        
        //Configuracion de botones
        PokemonManager.delegate = self
        ImageManager.delegate = self
        
    }
    
    
    @IBAction func buttomPressed(_ sender: UIButton) {
        print("Se preciono: \(sender.title(for: .normal) ?? "Esta vacio")")
    }
    
}

extension PokemonViewController: PokemonManagerDelegate{
    
    func didUpdatePokemon(pokemon: [PokemonModel]) {
        
        self.pokemon = pokemon
        
        let randomPokemon = pokemon.getFourRandomElements()
        
        for i in 0..<randomPokemon.count{
            DispatchQueue.main.async { [weak self] in
                self?.answerButtons[i].setTitle(randomPokemon[i].name.capitalized, for: .normal)
            }
        }
        
        let randomAnswer = Int.random(in: 0...3)
        correctAnswer = randomPokemon[randomAnswer].name
        
        ImageManager.fetchPokemon(urlString: randomPokemon[randomAnswer].imageURL)
        
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
    
}

extension PokemonViewController: ImageManagerDelegate {
    
    func didUpdateImage(imageModel: ImageModel) {
        print(imageModel)
    }
    
}

extension Array {
    func getFourRandomElements() -> Array {
        let shuffledArray = self.shuffled()
        let result = Array(shuffledArray.prefix(4))
        return result
    }
}
