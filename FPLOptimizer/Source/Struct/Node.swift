//
//  Node.swift
//  Branch and Bound
//
//  Created by David Pugh on 05/01/2020.
//  Copyright © 2020 David Pugh. All rights reserved.
//

import Foundation

struct Node {
    var level: Int = 0
    var profit: Double = 0
    var bound: Double = 0
    var weight: Double = 0
}
