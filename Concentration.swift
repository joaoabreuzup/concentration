//
//  Concentration.swift
//  Concentration
//
//  Created by João Jacó Santos Abreu on 22/01/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import Foundation

struct Concentration {
    
    private(set) var cards = [Card]()
    var numberOfMatches = 0
    private var indexOfOneAndOnlyFaceuUpCard: Int?
    {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    }
                    else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set(newValue) {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    var isGamefinished: Bool {
        return numberOfMatches == cards.count/2
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card,card]
        }
    }
    
    mutating func chooseCard(at index: Int){
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceuUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    self.numberOfMatches+=1
                }
                cards[index].isFaceUp = true
            } else {
                // nenhuma carta está virada pra cima ou 2 cartas estão viradas pra cima
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                    cards[index].isFaceUp = true
                }
            }
        }
    }
    
    mutating func shuffleCards(){
        self.cards.shuffle()
    }
    
    
    
}
