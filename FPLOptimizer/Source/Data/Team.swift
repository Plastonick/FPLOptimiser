//
//  Team.swift
//  FPL Optimizer
//  Created by David Pugh on 26/06/2019.
//  Copyright © 2019 Plastonick. All rights reserved.
//

import Foundation

class Team {
//    let money: Float
    let squads: [Squad]
	let transfers: [Int: [Transfer]]
    
    init (squads: [Squad], transfers: [Int: [Transfer]]) {
        self.squads = squads
        self.transfers = transfers
    }
	
	func makeTransfer(week: Int, transfer: Transfer) -> Team {
		// TODO check if either player is already being transferred this week
        var newTransfers = self.transfers
		
		// add to list of transfers
        if newTransfers[week] != nil {
            newTransfers[week]!.append(transfer)
        } else {
            newTransfers[week] = [transfer]
        }

        // adjust squad
        let currentSquad = getSquadFor(week: week)
        var newPlayers = currentSquad!.getPlayers().filter({ $0.id != transfer.playerOut.id })
        newPlayers.append(transfer.playerIn)

        var newSquads = self.squads

		// adjust future squads
        for eachWeek in (week...38) {
            // wipe future transfers for now, since they're possibly incompatible
            if eachWeek > week {
                newTransfers[eachWeek] = []
            }

            // change week
            for (index, squad) in squads.enumerated() {
                if squad.week >= eachWeek {
                    newSquads[index] = Squad(players: newPlayers, week: eachWeek)
                }
            }
        }

        return Team(squads: newSquads, transfers: newTransfers)
	}

    func isValid() -> Bool {
        for squad in squads {
            if !squad.isValid() {
                return false
            }
        }

        return true
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

    func getSquadFor(week: Int) -> Squad? {
        return squads.filter({ $0.week == week }).first
    }
}
