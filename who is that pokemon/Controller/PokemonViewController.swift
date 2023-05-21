//
//  ViewController.swift
//  who is that pokemon
//
//  Created by Alex Camacho on 01/08/22.
//

import UIKit
import Kingfisher

class PokemonViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet var answerButtons: [UIButton]!
    
    //MARK: Variables
    var pokemon: [PokemonModel] = []
    var correctAnswer: String = ""
    var correctImage: String = ""
    lazy var game = GameModel()
    

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
        
        labelScore.text = "Puntaje: \(game.getScore())"
        labelMessage.text = ""
    }
    
    private func setupDelegates(){
        
        //Configuracion de botones
        PokemonManager.delegate = self
        ImageManager.delegate = self
        
    }
    
    private func setupNewOption(_ sender: UIButton){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){ [weak self] in
            self?.labelMessage.text = ""
            sender.layer.borderColor = UIColor.clear.cgColor
            sender.layer.borderWidth = 0
            
            self?.getOtherOption()
            
        }
        
    }
    
    private func getOtherOption(){
        let randomPokemon = pokemon.getFourRandomElements()
        
        for i in 0..<randomPokemon.count{
            answerButtons[i].setTitle(randomPokemon[i].name.capitalized, for: .normal)
        }
        
        let randomAnswer = Int.random(in: 0...3)
        correctAnswer = randomPokemon[randomAnswer].name
        print(correctAnswer)
        
        ImageManager.fetchPokemon(urlString: randomPokemon[randomAnswer].imageURL)
    }
    
    
    @IBAction func buttomPressed(_ sender: UIButton) {
        
        let userAnswer = sender.title(for: .normal) ?? "Esta vacio"
        
        if game.checkAnswer(userAnswer, correctAnswer){
            if let url = URL(string: correctImage){
                pokemonImage.kf.setImage(with: url)
            }
            
            labelMessage.text = "Sí, es un \(correctAnswer.capitalized)"
            
            labelScore.text = "Puntaje: \(game.getScore())"
            
            sender.layer.borderColor = UIColor.green.cgColor
            sender.layer.borderWidth = 2
            
            
            setupNewOption(sender)
            
            
        }else{
            
            sender.layer.borderColor = UIColor.red.cgColor
            sender.layer.borderWidth = 2
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){[weak self] in
                self?.setupNewOption(sender)
                self?.performSegue(withIdentifier: "goToResult", sender: nil)
            }
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destination = segue.destination as! ResultsViewController
            
            destination.pokemonName = correctAnswer
            destination.pokemonImageURL = correctImage
            destination.finalScore = game.getScore()
            
        }
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
        print(correctAnswer)
        
        ImageManager.fetchPokemon(urlString: randomPokemon[randomAnswer].imageURL)
        
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
    
}

extension PokemonViewController: ImageManagerDelegate {
    
    func didUpdateImage(imageModel: ImageModel) {
        
        correctImage = imageModel.imageURL
        
        DispatchQueue.main.async {[weak self] in
            if let url = URL(string: imageModel.imageURL){
                let effect = ColorControlsProcessor(brightness: -1, contrast: 1, saturation: 1, inputEV: 0)
                self?.pokemonImage.kf.setImage(
                    with: url,
                    options: [
                        .processor(effect)
                    ]
                )
            }
        }
        
    }
    
}

extension Array {
    func getFourRandomElements() -> Array {
        let shuffledArray = self.shuffled()
        let result = Array(shuffledArray.prefix(4))
        return result
    }
}
