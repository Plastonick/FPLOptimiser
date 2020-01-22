//
//  Team.swift
//  FPL Optimizer
//
//  Created by David Pugh on 26/06/2019.
//  Copyright © 2019 Plastonick. All rights reserved.
//

import Foundation

struct Squad {
    let group: Group
    let week: Int
	
    init (players: [Player], week: Int) {
        self.group = Group(players: players)
        self.week = week
	}
    
    func getPlayers() -> [Player] {
        return self.group.getPlayers()
    }
    
    func withPlayers(players: [Player]) -> Squad {
        let newPlayers = self.getPlayers() + players
	
		return Squad(players: newPlayers, week: self.week)
    }
	
	func isExcessive() -> Bool {
        return self.group.isExcessive()
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
        return self.group.isValid()
    }

    public func hasExceededTeamLimit() -> Bool {
        return self.group.hasExceededTeamLimit()
    }

    public func hasExceededPositionLimits() -> Bool {
        return self.group.hasExceededPositionLimits()
    }
}
