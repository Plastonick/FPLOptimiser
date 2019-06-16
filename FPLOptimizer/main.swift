//
//  main.swift
//  FPLOptimizer
//
//  Created by David Pugh on 02/06/2019.
//  Copyright © 2019 Plastonick. All rights reserved.
//

import Foundation


let filename: String = "/Users/david/fpl-predictions.json"
if let url = Bundle.main.url(forResource: filename, withExtension: "json") {
    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()
    let jsonData = try decoder.decode(with: data)
    
    print(jsonData)
}

print(Position(rawValue: 4)!)
