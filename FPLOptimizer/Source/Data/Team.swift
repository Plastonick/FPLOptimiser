//
//  Team.swift
//  FPL Optimizer
//  Created by David Pugh on 26/06/2019.
//  Copyright © 2019 Plastonick. All rights reserved.
//

import Foundation

class Team {
    var squads: [Squad]
	var transfers: [Int: [Transfer]] = [:]
    
    init (squads: [Squad]) {
        self.squads = squads
    }
	
	func makeTransfer(week: Int, transfer: Transfer) {
		// check if either player is already being transferred this week
		
		// add to list of transfers
        if self.transfers[week] != nil {
            self.transfers[week]!.append(transfer)
        } else {
            self.transfers[week] = [transfer]
        }
		
		// adjust future squads
        for eachWeek in (week...38) {
            // wipe future transfers for now, since they're possibly incompatible
            transfers[week] = []
            
            // apply all current transfers
        }
	}
    
    func printScore() {
        for squad in squads {
            print("Week " + String(squad.week) + " -> " + String(format: "%.1f", squad.getScore()))
        }
        
        print("Total Score: " + String(format: "%.1f", self.getScore()))
    }
	
	func getScore() -> Float {
		return squads.reduce(0.0, { $0 + $1.getScore() })
	}
	
	func getCost() -> Int {
		// this doesn't really make sense... costs don't sum over weeks
		
		return squads.first!.getCost()
	}
}
