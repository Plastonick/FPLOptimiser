//
//  PredictionHydrator.swift
//  FPL Optimizer
//
//  Created by David Pugh on 04/06/2019.
//  Copyright © 2019 Plastonick. All rights reserved.
//

import Foundation

struct Optimizer {
    let players: [Player]
    
    init (players: [Player]) {
        self.players = players
    }
    
    func buildInitialTeam() -> Squad {
        let gameId = 3
        let sortedPlayers = players.sorted(by: {
            let player1Efficiency: Float = $0.getScoreByGame(id: gameId) / Float($0.getCostForGame(id: gameId))
            let player2Efficiency: Float = $1.getScoreByGame(id: gameId) / Float($1.getCostForGame(id: gameId))
            
            return player1Efficiency > player2Efficiency
        })
        
        var squad = Squad(players: [], gameId: gameId)
        var newSquad: Squad
        
        for player in sortedPlayers {
            newSquad = squad.withPlayers(players: [player])
            
            if !newSquad.isExcessive() {
                squad = newSquad
                
                if squad.isValid() {
                    break
                }
            }
        }
        
        return squad
    }
}
