//
//  ViewController.swift
//  who is that pokemon
//
//  Created by Alex Camacho on 01/08/22.
//

import UIKit

class PokemonViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var labelScore: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet var answerButtons: [UIButton]!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        
        //Configuracion de botones
        for buttom in answerButtons {
            buttom.layer.cornerRadius = 10
            buttom.layer.masksToBounds = false
        }
        
    }
    
    
    @IBAction func buttomPressed(_ sender: UIButton) {
        print("Se preciono: \(sender.title(for: .normal) ?? "Esta vacio")")
    }
    
    
}
