//
//  Preditiction.swift
//  FPLOptimizer
//
//  Created by David Pugh on 02/06/2019.
//  Copyright © 2019 Plastonick. All rights reserved.
//

import Foundation

struct Prediction: Decodable {
    let gameWeekId: Int
    let score: Float
    let chanceOfPlaying: Float
    let cost: Int
    
    init (gameWeekId: Int, score: Float, chanceOfPlaying: Float, cost: Int) {
        self.gameWeekId = gameWeekId
        self.score = score
        self.chanceOfPlaying = chanceOfPlaying
        self.cost = cost
    }
}
