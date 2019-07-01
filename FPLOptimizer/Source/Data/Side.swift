//
//  Team.swift
//  FPL Optimizer
//
//  Created by David Pugh on 26/06/2019.
//  Copyright © 2019 Plastonick. All rights reserved.
//

import Foundation

struct Side {
	let players: [Player]
	
	init (players: [Player]) {
		self.players = players
	}
    
    func withPlayers(players: [Player]) -> Side {
        let newPlayers = self.players + players
        
        return Side(players: newPlayers)
    }
	
	func isValid() -> Bool {
		if !isValidPlayerCounts() {
			return false
		}
		
		return isValidTeams()
	}
	
	private func isValidPlayerCounts() -> Bool {
		let goalKeepers = players.filter({ $0.position == .goalkeeper })
		let defenders = players.filter({ $0.position == .defender })
		let midfielders = players.filter({ $0.position == .midfielder })
		let forwards = players.filter({ $0.position == .forward })
		
		return players.count == 15
			&& goalKeepers.count == 2
			&& defenders.count == 5
			&& midfielders.count == 5
			&& forwards.count == 3
	}
	
	private func isValidTeams() -> Bool {
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
                return false
            }
        }
        
        return true
	}
}
