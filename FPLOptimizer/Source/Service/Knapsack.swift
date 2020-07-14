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
    let itemsByEfficiencyDictionary: [Int: [Item]]
    let itemsOrderedByValue: [Item]
    let week: Int
    let weightLimit: Double
    var maxProfit: Double = 94.85
    var bestItems: [Item] = []

    init (items: [Item], week: Int, weightLimit: Double) {
        // build items by their efficiency (value per weight)
        var itemsByEfficiency = items.sorted(by: {
            ($0.value / $0.weight) > ($1.value / $1.weight)
        })
        let itemsByValue = items.sorted(by: {
            $0.value > $1.value
        })

        self.itemsOrderedByValue = itemsByValue

        // build dictionaries containing a list of items sorted by efficiency,
        // but excluding the top 'n' players by absolute value
        // since we enumerate over players by total value later on, we want an
        // ordered list of players by efficiency omitting players with a total
        // value greater than a certain amount, so we can work out a feasible
        // upper bound
        var itemsByEfficiencyDictionary: [Int: [Item]] = [:]
        for (level, item) in self.itemsOrderedByValue.enumerated() {
            itemsByEfficiency = itemsByEfficiency.filter(
                { $0.player.id != item.player.id }
            )
            itemsByEfficiencyDictionary[level] = itemsByEfficiency
        }

        self.itemsByEfficiencyDictionary = itemsByEfficiencyDictionary
        self.nodeCount = items.count
        self.weightLimit = weightLimit
        self.week = week
    }

    // TODO create an initial naive guess to give a bound with which to work with. It should help ignore invalid solutions quicker

    public func solve() -> (Double, [Item]) {
        // make a queue for traversing the node
        var queue = Queue<Node>()
		var u = Node(level: -1, value: 0, captainBonus: 0, weight: 0, goalkeeperCount: 0, defenderCount: 0, midfielderCount: 0, forwardCount: 0, teamCount: [:], items: [], upperBounds: [])

        // dummy node at starting
        queue.write(u)

        // One by one extract an item from decision tree
        // compute profit of all children of extracted item
        // and keep saving maxProfit
        var i = 0
        while !queue.isEmpty {
            i += 1
			
            // Dequeue a node
            u = queue.read()!

            let level = u.level + 1
			
			// check that our last bound hasn't already been exceeded
			if u.upperBounds.count > 0 && u.upperBounds.last! < self.maxProfit {
				continue
			}

            // If there is nothing on next level
            if (level == self.nodeCount) {
                continue
            }

            var nodeWithPlayer = u.withItem(item: self.itemsOrderedByValue[level])

            let withPlayerIsValid = self.nodeIsValid(nodeWithPlayer)
            let boundWithPlayer = bound(node: nodeWithPlayer)
			
			nodeWithPlayer = nodeWithPlayer.setUpperBound(upperBound: boundWithPlayer)

            if withPlayerIsValid && boundWithPlayer > self.maxProfit {
                if nodeWithPlayer.items.count == 15 {
					if nodeWithPlayer.calculateTeamScore() > self.maxProfit {
						self.maxProfit = nodeWithPlayer.calculateTeamScore()
						self.bestItems = nodeWithPlayer.items
						
						print(self.maxProfit)
						nodeWithPlayer.printNode()
						exit(0)
					}
                } else {
                    // This isn't a complete team yet, but the score upper bound is greater than the current best team,
					// so we consider this as a potential blueprint
                    queue.write(nodeWithPlayer)
                }
            }

            if i % 100000 == 0 {
                print(i)

//                if i >= 15000000 {
//                    break
//                }
            }

            // Consider if omitting the player could give a feasible improved solution, add it for consideration if so
            var nodeWithoutPlayer = u.withoutItem()
            let boundWithoutPlayer = bound(node: nodeWithoutPlayer)
            if boundWithoutPlayer > self.maxProfit {
				nodeWithoutPlayer = nodeWithoutPlayer.setUpperBound(upperBound: boundWithoutPlayer)
                queue.write(nodeWithoutPlayer)
            }
        }

        print("Computed in \(i) iterations.")

        return (self.maxProfit, self.bestItems)
    }

    fileprivate func bound(node: Node) -> Double {
        // if weight overcomes the knapsack capacity, return
        // 0 as expected bound, since it's an impossible solution
        if node.weight > self.weightLimit {
            return 0.0
        }
		
		// if the node already has the maximum players, the upper bound is the same as the value; partial inclusions of
		// players only makes sense when we have space in the team
		if node.items.count == 15 {
			return node.calculateTeamScore()
		}
		
		// TODO consider finding the highest value applicable player if there is a single slot remaining
		
		var upperBound: Node = node
		
		let itemsRemaining = self.getItemEfficiencyListFor(level: node.level)
		
		var index: Int = 0
		var considerPlayer = itemsRemaining[index]
		while upperBound.weight + considerPlayer.weight <= self.weightLimit {
			upperBound = upperBound.withItem(item: considerPlayer)
			index += 1
			
			// there are no more players to consider -- return the current team score
			if index >= itemsRemaining.count {
				return upperBound.calculateTeamScore()
			}
			
			considerPlayer = itemsRemaining[index]
		}

		var profitBound = upperBound.calculateTeamScore()
		
		// we have partial weight remaining, assume we can include a fraction of a player for a better upper bound
		if (upperBound.weight < self.weightLimit) {
			let playerInclusionAmount = (self.weightLimit - upperBound.weight) / considerPlayer.weight
			profitBound += playerInclusionAmount * considerPlayer.value
		}

        return profitBound
    }
	
	fileprivate func getItemEfficiencyListFor(level: Int) -> [Item] {
		return self.itemsByEfficiencyDictionary[level]!
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
