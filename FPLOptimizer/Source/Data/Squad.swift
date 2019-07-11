//
//  Team.swift
//  FPL Optimizer
//
//  Created by David Pugh on 26/06/2019.
//  Copyright © 2019 Plastonick. All rights reserved.
//

import Foundation

struct Squad {
    let goalkeepers: [Player]
    let defenders: [Player]
    let midfielders: [Player]
    let forwards: [Player]
    let gameId: Int
	
    init (players: [Player], gameId: Int) {
        self.goalkeepers = players.filter({ $0.position == Position.goalkeeper })
        self.defenders = players.filter({ $0.position == Position.defender })
        self.midfielders = players.filter({ $0.position == Position.midfielder })
        self.forwards = players.filter({ $0.position == Position.forward })
        self.gameId = gameId
	}
    
    func getPlayers() -> [Player] {
        return goalkeepers + defenders + midfielders + forwards
    }
    
    func withPlayers(players: [Player]) -> Squad {
        let newPlayers = getPlayers() + players
        
        return Squad(players: newPlayers, gameId: self.gameId)
    }
	
	func isExcessive() -> Bool {
		if hasExceededPositionCounts() {
			return true
		}
		
		return hasExceededTeamCount()
	}
    
    private func scoreComp(a: Player, b: Player) -> Bool {
        return a.getCostForGame(id: gameId) > b.getCostForGame(id: gameId)
    }
    
    func getScore() -> Float {
        // TODO take into account benched players
        
        return getPlayers().reduce(0.0, { $0 + $1.getScoreByGame(id: gameId) })
    }
    
    func getCost() -> Int {
        return getPlayers().reduce(0, { $0 + $1.getCostForGame(id: gameId) })
    }
    
    func isValid() -> Bool {
        return self.goalkeepers.count == 2
            && self.defenders.count == 5
            && self.midfielders.count == 5
            && self.forwards.count == 3
    }
	
	private func hasExceededPositionCounts() -> Bool {
        return self.goalkeepers.count > 2
            || self.defenders.count > 5
            || self.midfielders.count > 5
            || self.forwards.count > 3
	}
	
	private func hasExceededTeamCount() -> Bool {
        var teamCount = [Int:Int]()
        
        for player in getPlayers() {
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
