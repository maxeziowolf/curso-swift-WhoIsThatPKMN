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
    @IBOutlet weak var containerStack: UIStackView!
    @IBOutlet weak var liveStack: UIStackView!
    
    //MARK: Constrains
    @IBOutlet weak var firstContentConstraint: NSLayoutConstraint!
    
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        //Este metodo se ejecutara justo antes de empezar la configuraicon para rotar el dispositivo.
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let interfaceOrientation = windowScene.interfaceOrientation
            switch interfaceOrientation {
            case .portrait:
                // La orientación es vertical (retrato)
                updatePortrairView()
                break
            case .landscapeLeft, .landscapeRight:
                // La orientación es horizontal (paisaje)
                updateLandscapeView()
                break
            default:
                // Nueva orientación agregada en futuras versiones de iOS
                print("Ocurrio una situacion no esperada 💻")
                break
            }
        }
        
    }
    
    private func updateLandscapeView(){
        
        containerStack.axis = .horizontal
        firstContentConstraint.priority = .defaultLow
        
    }
    
    private func updatePortrairView(){
        
        containerStack.axis = .vertical
        firstContentConstraint.priority = .defaultHigh
        view.layoutIfNeeded()
        
    }
    
    private func setupUI(){
        
        //Configuracion de botones
        for buttom in answerButtons {
            buttom.layer.cornerRadius = 10
            buttom.layer.masksToBounds = false
        }
        
        labelScore.text = "Puntaje: \(game.getScore())"
        labelMessage.text = ""
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let interfaceOrientation = windowScene.interfaceOrientation
            if interfaceOrientation == .landscapeLeft || interfaceOrientation == .landscapeRight{
                updateLandscapeView()
            }
        }
        
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
            
            
            
        }else if game.getLiveCount() > 0{
            
            let lastHeart = liveStack.arrangedSubviews.last { view in
                if let imageHeart = view as? UIImageView, imageHeart.image?.pngData() == UIImage(systemName: "heart.fill")?.pngData() {
                    
                    UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
                        imageHeart.transform = imageHeart.transform.scaledBy(x: 0.1, y: 0.1)
                    } completion: { _ in
                        imageHeart.image = UIImage(systemName: "heart")
                        imageHeart.transform = .identity
                    }

                    
                    return true
                }
                
                return false
            }
            
            sender.layer.borderColor = UIColor.red.cgColor
            sender.layer.borderWidth = 2
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){[weak self] in
                self?.setupNewOption(sender)
            }
            
            
        }else{
            

            
            sender.layer.borderColor = UIColor.red.cgColor
            sender.layer.borderWidth = 2
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){[weak self] in
                self?.setupNewOption(sender)
                self?.performSegue(withIdentifier: "goToResult", sender: nil)
                self?.game.setScrore(score: 0)
                self?.labelScore.text = "Puntaje: \(self?.game.getScore() ?? 0)"
                self?.game.setLive(liveCount: 4)
                
                self?.liveStack.arrangedSubviews.forEach({ view in
                    if let imageHeart = view as? UIImageView{
                        imageHeart.image = UIImage(systemName: "heart.fill")
                    }
                })
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
