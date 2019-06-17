//
//  main.swift
//  FPLOptimizer
//
//  Created by David Pugh on 02/06/2019.
//  Copyright © 2019 Plastonick. All rights reserved.
//

import Foundation


let fileName: String = "fpl-predictions.json"
var filePath: String = "/Users/david/fpl-predictions.json"

// Read file content. Example in Swift
do {
	// Read file content
	let contentFromFile = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
	print(contentFromFile.substring(to: 100))
	
	
	let path = Bundle.main.path(forResource: filePath, ofType: "json")!
	let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
	
	let myStructArray = try JSONDecoder().decode([Player].self, from: data)
	
	print(myStructArray.count)
} catch let error as NSError {
	print("An error took place: \(error)")
}

