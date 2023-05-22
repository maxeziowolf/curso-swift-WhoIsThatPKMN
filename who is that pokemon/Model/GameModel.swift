//
//  GameModel.swift
//  who is that pokemon
//
//  Created by Maximiliano Ovando Ramírez on 20/05/23.
//

import Foundation

struct GameModel{
    private var score = 0
    private var liveCount = 4
    
    // Revisar respuesta correcta
    mutating func checkAnswer(_ userAnswer: String, _ correctAnswer: String) -> Bool {
        
        let checkAnswer = userAnswer.lowercased() == correctAnswer.lowercased()
        
        if checkAnswer{
            score += 10
        }else{
            liveCount -= 1
        }
        
        return checkAnswer
    }
    
    func getScore() -> Int{
        return score
    }
    
    mutating func setScrore(score: Int){
        self.score = score
    }
    
    func getLiveCount()-> Int{
        return liveCount
    }
    
    mutating func setLive(liveCount: Int){
        self.liveCount = liveCount
    }
    
    
    
    
}
