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
        
    }
    
    @IBAction func playAgainPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    

}
