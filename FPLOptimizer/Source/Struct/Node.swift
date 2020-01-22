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
    let profit: Double
    let weight: Double
    let goalkeeperCount: Int
    let defenderCount: Int
    let midfielderCount: Int
    let forwardCount: Int
    let teamCount: [Int: Int]
    let items: [Item]

    init (
        level: Int,
        profit: Double,
        weight: Double,
        goalkeeperCount: Int,
        defenderCount: Int,
        midfielderCount: Int,
        forwardCount: Int,
        teamCount: [Int: Int],
        items: [Item]
    ) {
        self.level = level
        self.profit = profit
        self.weight = weight
        self.goalkeeperCount = goalkeeperCount
        self.defenderCount = defenderCount
        self.midfielderCount = midfielderCount
        self.forwardCount = forwardCount
        self.teamCount = teamCount
        self.items = items
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

        return Node(
            level: self.level + 1,
            profit: self.profit + item.value,
            weight: self.weight + item.weight,
            goalkeeperCount: goalkeeperCount,
            defenderCount: defenderCount,
            midfielderCount: midfielderCount,
            forwardCount: forwardCount,
            teamCount: teamCount,
            items: self.items + [item]
        )
    }

    public func withoutItem() -> Node {
        return Node(
            level: self.level + 1,
            profit: self.profit,
            weight: self.weight,
            goalkeeperCount: self.goalkeeperCount,
            defenderCount: self.defenderCount,
            midfielderCount: self.midfielderCount,
            forwardCount: self.forwardCount,
            teamCount: teamCount,
            items: self.items
        )
    }
}
