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

	let players = try decoder.decode([Player].self, from: jsonData)
	let sortedPlayers = players.sorted {
		$0.sc
	}
	
	print(players.count)
	
	let somePlayers = Array(players.prefix(5))
	
	let team = Team(players: somePlayers)
	
	if (team.isValid()) {
		print("is valid!")
	} else {
		print("oh no!")
	}

} catch let error {
	print("An error took place: \(error)")
}

