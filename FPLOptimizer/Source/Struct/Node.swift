//
//  Node.swift
//  Branch and Bound
//
//  Created by David Pugh on 05/01/2020.
//  Copyright © 2020 David Pugh. All rights reserved.
//

import Foundation

struct Node {
    let level: Int
    let value: Double
    let captainBonus: Double
    let weight: Double
    let goalkeeperCount: Int
    let defenderCount: Int
    let midfielderCount: Int
    let forwardCount: Int
    let teamCount: [Int: Int]
	let items: [Item]
	let upperBounds: [Double]

    init (
        level: Int,
        value: Double,
        captainBonus: Double,
        weight: Double,
        goalkeeperCount: Int,
        defenderCount: Int,
        midfielderCount: Int,
        forwardCount: Int,
        teamCount: [Int: Int],
        items: [Item],
		upperBounds: [Double]
    ) {
        self.level = level
        self.value = value
        self.captainBonus = captainBonus
        self.weight = weight
        self.goalkeeperCount = goalkeeperCount
        self.defenderCount = defenderCount
        self.midfielderCount = midfielderCount
        self.forwardCount = forwardCount
        self.teamCount = teamCount
		self.items = items
		self.upperBounds = upperBounds
    }

    public func calculateTeamScore() -> Double {
        return self.value + self.captainBonus
    }

    public func withItem(item: Item) -> Node {
        var goalkeeperCount = self.goalkeeperCount
        var defenderCount = self.defenderCount
        var midfielderCount = self.midfielderCount
        var forwardCount = self.forwardCount

        switch item.player.position {
            case Position.goalkeeper:
                goalkeeperCount += 1
                break
            case Position.defender:
                defenderCount += 1
                break
            case Position.midfielder:
                midfielderCount += 1
                break
            case Position.forward:
                forwardCount += 1
                break
        }

        var teamCount = self.teamCount
        if teamCount.keys.contains(item.player.team) {
            teamCount[item.player.team]! += 1
        } else {
            teamCount[item.player.team] = 1
        }

        let newCaptainBonus: Double = item.value > captainBonus ? item.value : self.captainBonus

        return Node(
            level: self.level + 1,
            value: self.value + item.value,
            captainBonus: newCaptainBonus,
            weight: self.weight + item.weight,
            goalkeeperCount: goalkeeperCount,
            defenderCount: defenderCount,
            midfielderCount: midfielderCount,
            forwardCount: forwardCount,
            teamCount: teamCount,
            items: self.items + [item],
			upperBounds: self.upperBounds
        )
    }
	
	public func setUpperBound(upperBound: Double) -> Node {
		return Node(
			level: self.level,
			value: self.value,
			captainBonus: self.captainBonus,
			weight: self.weight,
			goalkeeperCount: self.goalkeeperCount,
			defenderCount: self.defenderCount,
			midfielderCount: self.midfielderCount,
			forwardCount: self.forwardCount,
			teamCount: teamCount,
			items: self.items,
			upperBounds: upperBounds + [upperBound]
		)
	}

    public func withoutItem() -> Node {
        return Node(
            level: self.level + 1,
            value: self.value,
            captainBonus: self.captainBonus,
            weight: self.weight,
            goalkeeperCount: self.goalkeeperCount,
            defenderCount: self.defenderCount,
            midfielderCount: self.midfielderCount,
            forwardCount: self.forwardCount,
            teamCount: teamCount,
            items: self.items,
			upperBounds: self.upperBounds
        )
    }
	
	public func printNode() {
		var totalCost: Double = 0
		var totalScore: Double = 0
		var lastPosition: Position = Position.forward
		var player: Player
		for item in self.items.sorted(by: { $0.player.position.rawValue < $1.player.position.rawValue }) {
			player = item.player
			if player.position != lastPosition {
			  print("")
			  lastPosition = player.position
			}

			print("\(player.name): \(item.value)")
			totalCost += item.weight
			totalScore += item.value
		}
		
		print("")
		print("Total score: \(totalScore)")
		print("Total cost: \(totalCost)")
		print("")
		print("")
	}
}
