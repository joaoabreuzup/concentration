//
//  Card.swift
//  Concentration//
//  Created by João Jacó Santos Abreu on 22/01/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import Foundation

struct Card: Hashable {
    
    var hashValue: Int { return identifier }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
    
    private var identifier = 0
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() ->Int {
        identifierFactory += 1
        return  identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
}

