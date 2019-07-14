//
//  Team.swift
//  FPL Optimizer
//  Created by David Pugh on 26/06/2019.
//  Copyright © 2019 Plastonick. All rights reserved.
//

import Foundation

class Team {
    let squads: [Squad]
	var transfers: [Int: [Transfer]] = [:]
    
    init (squads: [Squad]) {
        self.squads = squads
    }
	
	func makeTransfer(week: Int, transfer: Transfer) {
		// check if either player is already being transferred this week
		
		// add to list of transfers
		
		// adjust future squads
	}
	
	func getScore() -> Float {
		return squads.reduce(0.0, { $0 + $1.getScore() })
	}
	
	func getCost() -> Int {
		// this doesn't really make sense... costs don't sum over weeks
		
		return squads.reduce(0, { $0 + $1.getCost() })
	}
}
