//
//  ResultsViewController.swift
//  who is that pokemon
//
//  Created by Maximiliano Ovando Ramírez on 20/05/23.
//

import UIKit
import Kingfisher

class ResultsViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var labelImage: UILabel!
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var containerStack: UIStackView!
    
    //Constrains
    @IBOutlet weak var firstContentConstraint: NSLayoutConstraint!
    
    
    //MARK: Variables
    var pokemonName :String = ""
    var pokemonImageURL: String = ""
    var finalScore: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelScore.text = "Perdiste, tu puntaje fue de \(finalScore)"
        labelImage.text = "No, es un \(pokemonName)"
        let url = URL(string: pokemonImageURL)
        pokemonImage.kf.setImage(with: url)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let interfaceOrientation = windowScene.interfaceOrientation
            if interfaceOrientation == .landscapeLeft || interfaceOrientation == .landscapeRight{
                updateLandscapeView()
            }
        }
        
        
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
    
    @IBAction func playAgainPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    

}
