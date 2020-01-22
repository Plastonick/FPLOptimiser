//
//  Item.swift
//  Branch and Bound
//
//  Created by David Pugh on 05/01/2020.
//  Copyright © 2020 David Pugh. All rights reserved.
//

import Foundation

struct Item {
    let player: Player
    let value: Double
    let weight: Double

    init(player: Player, value: Double, weight: Double) {
        self.player = player
        self.value = value
        self.weight = weight
    }
}
