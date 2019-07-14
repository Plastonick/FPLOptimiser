//
//  Transfer.swift
//  FPL Optimizer
//
//  Created by David Pugh on 11/07/2019.
//  Copyright © 2019 Plastonick. All rights reserved.
//

import Foundation

struct Transfer {
	let week: Int
	let playerIn: Player
	let playerOut: Player
	
	init(week: Int, playerIn: Player, playerOut: Player) {
		self.week = week
		self.playerIn = playerIn
		self.playerOut = playerOut
	}
}
