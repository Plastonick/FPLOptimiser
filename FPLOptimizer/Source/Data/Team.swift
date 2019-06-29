//
//  Team.swift
//  FPL Optimizer
//
//  Created by David Pugh on 26/06/2019.
//  Copyright © 2019 Plastonick. All rights reserved.
//

import Foundation

struct Team {
	let players: [Player]
	
	init (players: [Player]) {
		self.players = players
	}
	
	public func isValid() -> Bool {
		if !isValidPlayerCounts() {
			return false
		}
		
		return isValidPlayerCounts()
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
        return true
	}
}
