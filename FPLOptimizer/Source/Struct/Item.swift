//
//  Item.swift
//  Branch and Bound
//
//  Created by David Pugh on 05/01/2020.
//  Copyright © 2020 David Pugh. All rights reserved.
//

import Foundation

struct Item {
    let name: String
    let value: Double
    let weight: Double

    init(name: String, value: Double, weight: Double) {
        self.name = name
        self.value = value
        self.weight = weight
    }
}
