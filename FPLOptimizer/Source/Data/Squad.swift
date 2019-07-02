//
//  Team.swift
//  FPL Optimizer
//
//  Created by David Pugh on 26/06/2019.
//  Copyright © 2019 Plastonick. All rights reserved.
//

import Foundation

struct Squad {
	let players: [Player]
    let gameId: Int
	
    init (players: [Player], gameId: Int) {
		self.players = players
        self.gameId = gameId
	}
    
    func withPlayers(players: [Player]) -> Squad {
        let newPlayers = self.players + players
        
        return Squad(players: newPlayers, gameId: self.gameId)
    }
	
	func isExcessive() -> Bool {
		if hasExceededPositionCounts() {
			return true
		}
		
		return hasExceededTeamCount()
	}
    
    func getScore() -> Float {
        return players.reduce(0.0, { $0 + $1.getScoreByGame(id: gameId) })
    }
    
    func getCost() -> Int {
        return players.reduce(0, { $0 + $1.getCostForGame(id: gameId) })
    }
    
    func isValid() -> Bool {
        return players.count == 15 && !isExcessive()
    }
	
	private func hasExceededPositionCounts() -> Bool {
        var positionCount = [
            Position.goalkeeper: 0,
            Position.defender: 0,
            Position.midfielder: 0,
            Position.forward: 0
        ]
        
        for player in players {
            positionCount[player.position]! += 1
        }
        
        return positionCount[Position.goalkeeper]! > 2
            || positionCount[Position.defender]! > 5
            || positionCount[Position.midfielder]! > 5
            || positionCount[Position.forward]! > 3
	}
	
	private func hasExceededTeamCount() -> Bool {
        var teamCount = [Int:Int]()
        
        for player in players {
            if teamCount.keys.contains(player.teamId) {
                teamCount[player.teamId]! += 1
            } else {
                teamCount[player.teamId] = 1
            }
        }
        
        for (_, count) in teamCount {
            if count > 3 {
                return true
            }
        }
        
        return false
	}
}
