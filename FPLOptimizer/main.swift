//
//  main.swift
//  FPLOptimizer
//
//  Created by David Pugh on 02/06/2019.
//  Copyright © 2019 Plastonick. All rights reserved.
//

import Foundation

var filePath: String = CommandLine.arguments[1]

do {
	// Read file content
	let jsonData = try Data(contentsOf: URL(fileURLWithPath: filePath))
	
	let decoder = JSONDecoder()

	var players = try decoder.decode([Player].self, from: jsonData)
    
    let gameId = 2
    
    players.sort(by: {
        let player1Efficiency: Float = $0.getScoreByGame(id: gameId) / Float($0.getCostForGame(id: gameId))
        let player2Efficiency: Float = $1.getScoreByGame(id: gameId) / Float($1.getCostForGame(id: gameId))
        
        return player1Efficiency > player2Efficiency
    })
	
    print(players.count)
	
	let side = Side(players: [])
	
    if (side.isValid()) {
		print("is valid!")
	} else {
		print("oh no!")
	}

} catch let error {
	print("An error took place: \(error)")
}

