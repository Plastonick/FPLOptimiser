//
//  Preditiction.swift
//  FPLOptimizer
//
//  Created by David Pugh on 02/06/2019.
//  Copyright © 2019 Plastonick. All rights reserved.
//

import Foundation

class Prediction {
    let player: Player
    let gameWeekId: Int
    let predictedScore: Float
    let chanceOfPlaying: Float
    let cost: Int
    
    init (player: Player, gameWeekId: Int, predictedScore: Float, chanceOfPlaying: Float, cost: Int) {
        self.player = player
        self.gameWeekId = gameWeekId
        self.predictedScore = predictedScore
        self.chanceOfPlaying = chanceOfPlaying
        self.cost = cost
    }
}
