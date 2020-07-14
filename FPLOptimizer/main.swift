//
//  main.swift
//  FPLOptimizer
//
//  Created by David Pugh on 02/06/2019.
//  Copyright © 2019 Plastonick. All rights reserved.
//

import Foundation

//DispatchQueue.concurrentPerform(iterations: 100000) { i in
//	let b = (0 ... i).reduce(0, +)
//
//	print(b)
//}


let filePath: String = CommandLine.arguments[1]

do {
    // Read file content
    let jsonData = try Data(contentsOf: URL(fileURLWithPath: filePath))

    let decoder = JSONDecoder()

	let players = try decoder.decode([Player].self, from: jsonData)

    var items: [Item] = []
    let weekNumber = 1

    for player in players {
        items.append(
            Item(
                player: player,
                value: Double(player.getScoreForWeek(week: weekNumber)),
                weight: Double(player.getCostForWeek(week: weekNumber))
            )
        )
    }

    let knapsack = Knapsack(items: items, week: weekNumber, weightLimit: 1000)
    let value = knapsack.solve()

    let returnedPlayers = value.1.map({ $0.player })
    let group = Group(players: returnedPlayers)

    print("Week \(weekNumber)")
    var totalCost: Int = 0
    var lastPosition: Position = Position.forward
    for player in group.getPlayers() {
        if player.position != lastPosition {
            print("")
            lastPosition = player.position
        }

        print("\(player.name): \(player.getScoreForWeek(week: weekNumber))")
        totalCost += player.getCostForWeek(week: weekNumber)
    }

    let totalScore = (value.0 * 1000).rounded() / 1000
    print("")
    print("Total score: \(totalScore)")
    print("Total cost: \(totalCost)")
    print(value.1.count)
    print("")
    print("")

//    let optimizer = Optimizer(players: players)

//    let bestKeeperPair = optimizer.getBestKeeperPair()

//    let team = optimizer.optimise()
//
//    print("Total cost: " + String(Float(team.getCost()) / 10))
    //    team.printScore()
    
} catch let error {
	print("An error took place: \(error)")
}

