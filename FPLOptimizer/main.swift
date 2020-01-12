//
//  main.swift
//  FPLOptimizer
//
//  Created by David Pugh on 02/06/2019.
//  Copyright © 2019 Plastonick. All rights reserved.
//

import Foundation


func bound(u: Node, n: Int, W: Double, itemLimit: Int, arr: [Item]) -> Double {
    // if weight overcomes the knapsack capacity, return
    // 0 as expected bound
    if (u.weight >= W) {
        return 0.0
    }

    // initialize bound on profit by current profit
    var profitBound: Double = u.profit

    // start including items from index 1 more to current
    // item index
    var currentLevel: Int = u.level + 1
    var totalWeight: Double = u.weight

    // checking index condition and knapsack capacity
    // condition
    while ((currentLevel < n) && (totalWeight + arr[currentLevel].weight <= W)) {
        totalWeight += arr[currentLevel].weight
        profitBound += arr[currentLevel].value
        currentLevel += 1
    }

    // If k is not n, include last item partially for
    // upper bound on profit
    if (currentLevel < n) {
        profitBound += (W - totalWeight) * arr[currentLevel].value / arr[currentLevel].weight
    }

    return profitBound
}

func knapsack(weightLimit: Double, itemLimit: Int, itemsUnsorted: [Item], numberOfItems: Int) -> Double {
    // sorting Item on basis of value per unit
    // weight.
    let items = itemsUnsorted.sorted(by: {
        ($0.value / $0.weight) > ($1.value / $1.weight)
    })

    // make a queue for traversing the node
    var queue = RingBuffer<Node>(count: items.count)
    var u = Node()
    var v = Node()

    u.level = -1
    u.profit = 0
    u.weight = 0

    // dummy node at starting
    queue.write(u)

    // One by one extract an item from decision tree
    // compute profit of all children of extracted item
    // and keep saving maxProfit
    var maxProfit: Double = 0
    var i = 0
    while (!queue.isEmpty)
    {
        i += 1
        // Dequeue a node
        u = queue.read()!

        // If it is starting node, assign level 0
        if (u.level == -1) {
            v.level = 0
        }

        // If there is nothing on next level
        if (u.level == numberOfItems - 1) {
            continue
        }

        // Else if not last node, then increment level,
        // and compute profit of children nodes.
        v.level = u.level + 1

        // Taking current level's item add current
        // level's weight and value to node u's
        // weight and value
        v.weight = u.weight + items[v.level].weight
        v.profit = u.profit + items[v.level].value

        // If cumulated weight is less than W and
        // profit is greater than previous profit,
        // update maxprofit
        if (v.weight <= weightLimit && v.profit > maxProfit) {
            maxProfit = v.profit
        }

        // Get the upper bound on profit to decide
        // whether to add v to Q or not.
        v.bound = bound(u: v, n: numberOfItems, W: weightLimit, itemLimit: itemLimit, arr: items)

        // If bound value is greater than profit,
        // then only push into queue for further
        // consideration
        if (v.bound > maxProfit) {
            queue.write(v)
        }

        // Do the same thing,  but Without taking
        // the item in knapsack
        v.weight = u.weight
        v.profit = u.profit
        v.bound = bound(u: v, n: numberOfItems, W: weightLimit, itemLimit: itemLimit, arr: items)
        if (v.bound > maxProfit) {
            queue.write(v)
        }
    }

    return maxProfit
}

















var filePath: String = CommandLine.arguments[1]

do {
	// Read file content
	let jsonData = try Data(contentsOf: URL(fileURLWithPath: filePath))

	let decoder = JSONDecoder()

	let players = try decoder.decode([Player].self, from: jsonData)

    var items: [Item] = []

    for player in players {
        items.append(Item(name: player.name, value: Double(player.getScoreForWeek(week: 1)), weight: Double(player.getCostForWeek(week: 1))))
    }

    let value = knapsack(weightLimit: 1000, itemLimit: 15, itemsUnsorted: items, numberOfItems: items.count)

    print(value)

//    let optimizer = Optimizer(players: players)

//    let bestKeeperPair = optimizer.getBestKeeperPair()

//    let team = optimizer.optimise()
//
//    print("Total cost: " + String(Float(team.getCost()) / 10))
//    team.printScore()
    
} catch let error {
	print("An error took place: \(error)")
}

