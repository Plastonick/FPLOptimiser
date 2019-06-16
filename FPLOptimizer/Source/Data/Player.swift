//
//  Player.swift
//  FPLOptimizer
//
//  Created by David Pugh on 04/06/2019.
//  Copyright © 2019 Plastonick. All rights reserved.
//

import Foundation

class Player {
    let id: Int
    let name: String
    let position: Position
    
    init (id: Int, name: String, position: Position) {
        self.id = id
        self.name = name
        self.position = position
    }
}
