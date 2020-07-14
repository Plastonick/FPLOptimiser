//
//  PredictionHydrator.swift
//  FPL Optimizer
//
//  Created by David Pugh on 04/06/2019.
//  Copyright © 2019 Plastonick. All rights reserved.
//

import Foundation

class Optimizer {
    let players: [Player]
    var team: Team
    
    init (players: [Player]) {
        self.players = players
        self.team = Team(squads: [], transfers: [:])

        self.team = buildInitialTeam()
    }

    func optimise() -> Team {
        let salah = players.filter({ $0.name == "Mohamed Salah" }).first

        tryPlayer(player: salah!, week: 3)

        return team
    }
    
    func buildInitialTeam() -> Team {
        let fromWeek = 1
        let toWeek = 5
        let sortedPlayers = players.sorted(by: {
            let player1Efficiency: Float = $0.getScoreBetweenWeeks(from: fromWeek, to: toWeek) / Float($0.getCostForWeek(week: fromWeek))
            let player2Efficiency: Float = $1.getScoreBetweenWeeks(from: fromWeek, to: toWeek) / Float($1.getCostForWeek(week: fromWeek))
            
            return player1Efficiency > player2Efficiency
        })
        
        var squad = Squad(players: [], week: fromWeek)
        var newSquad: Squad
		
        // Build initial team based on naively assigning players from score/cost until valid
        for player in sortedPlayers {
            if !player.playsInWeek(week: fromWeek) {
                continue
            }
            
            newSquad = squad.withPlayers(players: [player])
            
            if !newSquad.isExcessive() {
                squad = newSquad
                
                if squad.isValid() {
                    break
                }
            }
        }

        let squads = (1...38).map({ Squad(players: squad.getPlayers(), week: $0) })
		
        return Team(squads: squads, transfers: [:])
    }

    func tryPlayer(player: Player, week: Int) {
        let weekSquad = team.getSquadFor(week: week)
        let subs = weekSquad?.getPlayers().filter({ $0.position == player.position })

        var bestScore = team.getScore()
        var bestTeam = team
        for sub in subs! {
            let transfer = Transfer(week: week, playerIn: player, playerOut: sub)
            let newTeam = team.makeTransfer(week: week, transfer: transfer)

            if !newTeam.isValid() {
                continue
            }

            if newTeam.getScore() > bestScore {
                bestScore = newTeam.getScore()
                bestTeam = newTeam
            }
        }

        team = bestTeam
    }

    func getBestKeeperPair() -> [[Float]: [Player]] {
        let keepers = players.filter({ $0.position == Position.goalkeeper })

        var bestPairs: [([Float]): [Player]] = [:]
        for keeper1 in keepers {
            let secondaryKeepers = keepers.filter({ $0.id > keeper1.id })

            for keeper2 in secondaryKeepers {
                var score: Float = 0
                let cost: Float = Float(keeper1.getCostForWeek(week: 1) + keeper2.getCostForWeek(week: 1))

                for i in 1...19 {
                    let score1 = keeper1.getScoreForWeek(week: i)
                    let score2 = keeper2.getScoreForWeek(week: i)
                    score += max(score1, score2)
                }

                if score > 101 {
					var a = 1
                }

                var canAdd = true
                for (details, _) in bestPairs {
                    let bestCost = details.first!
                    let bestScore = details.last!

                    if cost <= bestCost && score >= bestScore {
                        // retrieved keeper pair dominates this "best" pair, so we remove them
                        bestPairs.removeValue(forKey: details)
                    }

                    if cost >= bestCost && score <= bestScore {
                        // there is already something dominating this pair, continue
                        canAdd = false
                        break
                    }
                }

                if canAdd {
                    bestPairs[[cost, score]] = [keeper1, keeper2]
                }
            }
        }

        let orderedPairs = bestPairs.sorted(by: {
            $0.key.last! / $0.key.first! < $1.key.last! / $1.key.first!
        })

        for (details, pair) in orderedPairs {
            print("Cost: " + String(details.first!))
            print("Score: " + String(details.last!))
            print("Value: " + String(details.last! / details.first!))

            for keeper in pair {
                print(keeper.name)
            }

            print("")
        }

        return bestPairs
    }
}
