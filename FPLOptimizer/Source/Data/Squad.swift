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
    let week: Int
	
    init (players: [Player], week: Int) {
        self.goalkeepers = players.filter({ $0.position == Position.goalkeeper })
        self.defenders = players.filter({ $0.position == Position.defender })
        self.midfielders = players.filter({ $0.position == Position.midfielder })
        self.forwards = players.filter({ $0.position == Position.forward })
        self.week = week
	}
    
    func getPlayers() -> [Player] {
        return goalkeepers + defenders + midfielders + forwards
    }
    
    func withPlayers(players: [Player]) -> Squad {
        let newPlayers = getPlayers() + players
	
		return Squad(players: newPlayers, week: self.week)
    }
	
	func isExcessive() -> Bool {
		if hasExceededPositionCounts() {
			return true
		}
		
		return hasExceededTeamCount()
	}
    
    private func scoreComp(a: Player, b: Player) -> Bool {
        return a.getCostForWeek(week: week) > b.getCostForWeek(week: week)
    }
    
    func getScore() -> Float {
        // TODO take into account benched players, captaincy, chance of playing, etc.
        
        return getPlayers().reduce(0.0, { $0 + $1.getScoreForWeek(week: week) })
    }
    
    func getCost() -> Int {
        return getPlayers().reduce(0, { $0 + $1.getCostForWeek(week: week) })
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
            if teamCount.keys.contains(player.team) {
                teamCount[player.team]! += 1
            } else {
                teamCount[player.team] = 1
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
