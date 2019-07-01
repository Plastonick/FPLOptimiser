//
//  Player.swift
//  FPLOptimizer
//
//  Created by David Pugh on 04/06/2019.
//  Copyright © 2019 Plastonick. All rights reserved.
//

import Foundation

class Player: Decodable {
    let id: Int
    let name: String
    let position: Position
    let teamId: Int
	let predictions: [Prediction]
    
    init (id: Int, name: String, position: Position, teamId: Int, predictions: [Prediction]) {
        self.id = id
        self.name = name
        self.position = position
        self.teamId = teamId
		self.predictions = predictions
    }
    
    func getCostForGame(id: Int) -> Int {
        if let prediction = predictions.filter({ $0.gameWeekId == id }).first {
            return prediction.cost
        }
        
        return Int.max
    }
    
    func getScoreByGame(id: Int) -> Float {
        if let prediction = predictions.filter({ $0.gameWeekId == id }).first {
            return prediction.score
        }
        
        // TODO
        return Float(0)
    }
}
