//
//  Knapsack.swift
//  FPL Optimizer
//
//  Created by David Pugh on 14/01/2020.
//  Copyright © 2020 Plastonick. All rights reserved.
//

import Foundation

class Knapsack {
    let nodeCount: Int
    let itemsByEfficiency: [Item]
    let itemsByEfficiencyDictionary: [Int: [Item]]
    let itemsByValue: [Item]
    let week: Int
    let weightLimit: Double
    var maxProfit: Double = 0
    var bestItems: [Item] = []

    init (items: [Item], week: Int, weightLimit: Double) {
        var itemsByEfficiency = items.sorted(by: {
            ($0.value / $0.weight) > ($1.value / $1.weight)
        })
        let itemsByValue = items.sorted(by: {
            $0.value > $1.value
        })

        self.itemsByEfficiency = itemsByEfficiency
        self.itemsByValue = itemsByValue
        var itemsByEfficiencyDictionary: [Int: [Item]] = [:]

        for (index, item) in self.itemsByValue.enumerated() {
            itemsByEfficiency = itemsByEfficiency.filter({ $0.player.id != item.player.id })
            itemsByEfficiencyDictionary[index] = itemsByEfficiency
        }

        self.itemsByEfficiencyDictionary = itemsByEfficiencyDictionary
        self.nodeCount = items.count
        self.weightLimit = weightLimit
        self.week = week
    }


    func bound(node: Node) -> Double {
        // if weight overcomes the knapsack capacity, return
        // 0 as expected bound
        if (node.weight >= self.weightLimit) {
            return 0.0
        }

        // initialize bound on profit by current profit
        var profitBound: Double = node.profit

        // start including items from index 1 more to current
        // item index
        var currentLevel: Int = node.level + 1
        var totalWeight: Double = node.weight

        while currentLevel < self.nodeCount && totalWeight + self.itemsByEfficiency[currentLevel].weight <= self.weightLimit {
            let itemByConsideration = self.itemsByEfficiency[currentLevel]
            currentLevel += 1
            totalWeight += itemByConsideration.weight
            profitBound += itemByConsideration.value
        }

        // If k is not n, include last item partially for
        // upper bound on profit
        if (currentLevel < self.nodeCount) {
            profitBound += (self.weightLimit - totalWeight) * self.itemsByEfficiency[currentLevel].value / self.itemsByEfficiency[currentLevel].weight
        }

        return profitBound
    }

    func solve() -> (Double, [Item]) {
        // make a queue for traversing the node
        var queue = buildQueue()
        var u = Node(level: -1, profit: 0, weight: 0, goalkeeperCount: 0, defenderCount: 0, midfielderCount: 0, forwardCount: 0, teamCount: [:], items: [])

        // dummy node at starting
        queue.write(u)

        // One by one extract an item from decision tree
        // compute profit of all children of extracted item
        // and keep saving maxProfit
        var i = 0
        while (!queue.isEmpty)
        {
            i += 1

            // Dequeue a node
            u = queue.read()!

            let level = u.level + 1

            // If there is nothing on next level
            if (level == self.nodeCount) {
                continue
            }

            let nodeWithPlayer = u.withItem(item: self.itemsByEfficiency[level])

            let withPlayerIsValid = self.nodeIsValid(nodeWithPlayer)
            let boundWithPlayer = bound(node: nodeWithPlayer)
            if withPlayerIsValid && boundWithPlayer > self.maxProfit {
                if nodeWithPlayer.profit > self.maxProfit && nodeWithPlayer.items.count == 15 {
                    self.maxProfit = nodeWithPlayer.profit
                    self.bestItems = nodeWithPlayer.items

                    print(self.maxProfit)
                } else {
                    // If bound value is greater than profit,
                    // then only push into queue for further
                    // consideration
                    queue.write(nodeWithPlayer)
                }
            }

            if i % 100000 == 0 {
                print(i)

//                if i >= 15000000 {
//                    break
//                }
            }


            // Do the same thing, but without taking the item in knapsack
            let nodeWithoutPlayer = u.withoutItem()
            let boundWithoutPlayer = bound(node: nodeWithoutPlayer)
            if boundWithoutPlayer > self.maxProfit {
                queue.write(nodeWithoutPlayer)
            }
        }

        print("Computed in \(i) iterations.")

        return (self.maxProfit, self.bestItems)
    }

    fileprivate func buildQueue() -> Queue<Node> {
        return Queue<Node>()
    }

    fileprivate func nodeIsValid(_ node: Node) -> Bool {
        if node.weight > self.weightLimit {
            return false
        }

        if self.nodeExceededPositionLimits(node) {
            return false
        }

        if self.nodeExceededTeamLimit(node) {
            return false
        }

        return true
    }

    fileprivate func nodeExceededTeamLimit(_ node: Node) -> Bool {
        for (_, count) in node.teamCount {
            if count > 3 {
                return true
            }
        }

        return false
    }

    fileprivate func nodeExceededPositionLimits(_ node: Node) -> Bool {
        if node.goalkeeperCount > 2 {
            return true
        }

        if node.defenderCount > 5 {
            return true
        }

        if node.midfielderCount > 5 {
            return true
        }

        if node.forwardCount > 3 {
            return true
        }

        return false
    }
}
