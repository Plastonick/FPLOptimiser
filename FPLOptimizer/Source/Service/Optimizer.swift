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
    
    func buildInitialTeam() -> Team {
        let fromWeek = 1
        let toWeek = 5
        let sortedPlayers = players.sorted(by: {
            let player1Efficiency: Float = $0.getScoreBetweenWeeks(from: fromWeek, to: toWeek) / Float($0.getCostForWeek(week: fromWeek))
            let player2Efficiency: Float = $1.getScoreBetweenWeeks(from: fromWeek, to: toWeek) / Float($1.getCostForWeek(week: fromWeek))
            
            return player1Efficiency > player2Efficiency
        })
        
        var squad = Squad(players: [], week: fromWeek)
        var newSquad: Squad
        
        for player in sortedPlayers {
            if !player.playsInWeek(week: fromWeek) {
                continue
            }
            
            newSquad = squad.withPlayers(players: [player])
            
            if !newSquad.isExcessive() {
                squad = newSquad
                
                if squad.isValid() {
                    break
                }
            }
        }

        let squads = (1...38).map({ Squad(players: squad.getPlayers(), week: $0) })
		
        return Team(squads: squads)
    }
}
