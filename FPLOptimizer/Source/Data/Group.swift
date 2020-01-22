//
//  Group.swift
//  FPL Optimizer
//
//  Created by David Pugh on 18/01/2020.
//  Copyright © 2019 Plastonick. All rights reserved.
//

import Foundation

struct Group {
    let goalkeepers: [Player]
    let defenders: [Player]
    let midfielders: [Player]
    let forwards: [Player]

    init (players: [Player]) {
        self.goalkeepers = players.filter({ $0.position == Position.goalkeeper })
        self.defenders = players.filter({ $0.position == Position.defender })
        self.midfielders = players.filter({ $0.position == Position.midfielder })
        self.forwards = players.filter({ $0.position == Position.forward })
    }

    func getPlayers() -> [Player] {
        return goalkeepers + defenders + midfielders + forwards
    }

    func isExcessive() -> Bool {
        if hasExceededPositionLimits() {
            return true
        }

        return hasExceededTeamLimit()
    }

    func isValid() -> Bool {
        if self.isExcessive() {
            return false
        }

        return self.goalkeepers.count == 2
            && self.defenders.count == 5
            && self.midfielders.count == 5
            && self.forwards.count == 3
    }

    public func hasExceededPositionLimits() -> Bool {
        return self.goalkeepers.count > 2
            || self.defenders.count > 5
            || self.midfielders.count > 5
            || self.forwards.count > 3
    }

    public func hasExceededTeamLimit() -> Bool {
        var teamCount = [Int:Int]()

        for player in getPlayers() {
            if teamCount.keys.contains(player.team) {
                if (teamCount[player.team] == 3) {
                    return true
                }

                teamCount[player.team]! += 1
            } else {
                teamCount[player.team] = 1
            }
        }

        return false
    }
}
