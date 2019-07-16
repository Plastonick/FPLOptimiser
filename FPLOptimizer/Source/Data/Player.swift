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
    let team: Int
	let predictions: [Prediction]
    
    init (id: Int, name: String, position: Position, team: Int, predictions: [Prediction]) {
        self.id = id
        self.name = name
        self.position = position
        self.team = team
		self.predictions = predictions
    }
    
    func playsInWeek(week: Int) -> Bool {
        return predictions.filter({ $0.week == week }).first != nil
    }
    
    func getCostForWeek(week: Int) -> Int {
        if let prediction = predictions.filter({ $0.week == week }).first {
            return prediction.cost
        }
        
        return Int.max
    }
    
    func getScoreForWeek(week: Int) -> Float {
		let games = predictions.filter({ $0.week == week })
		
		return games.reduce(0.0, { $0 + $1.score })
    }

    func getScoreBetweenWeeks(from: Int, to: Int) -> Float {
        let games = predictions.filter({ $0.week >= from && $0.week <= to })

        return games.reduce(0.0, { $0 + $1.score })
    }
}
