//
//  SetGame.swift
//  SetGame
//
//  Created by Pranay Kumar Srivastava on 24/11/18.
//  Copyright © 2018 Pranay Kumar Srivastava. All rights reserved.
//

import Foundation

class SetGame {
    private var cards = [Card]()
    var selectedCard = [Int]()
    
    init(){
//        Add 81 cards
        for color in Card.Color.allCases {
            for shade in Card.Shading.allCases {
                for symbol in Card.Symbol.allCases {
                    for num in 1...3 {
                        cards.append(
                            Card(color: color,number: num,  shading: shade, symbol: symbol, isPlayed: false,
                                 cardIsDealt: false  )
                        )
                    }
                }
            }
        }
    }
    
    func isASet(card1Index :Int, card2Index: Int, card3Index: Int,
                withCallback:(Bool)-> Void) -> Bool {
        if (checkBounds(index: card1Index) &&
            checkBounds(index: card2Index) &&
            checkBounds(index: card3Index)) {
            
            //Check if two are same.
            let isASet =  cards[card1Index].isASetWithPair(card1: cards[card3Index], card2: cards[card2Index])
            
            withCallback(isASet)
            return isASet
        }
        return false
    }
    
    func markCardsAsPlayed(card1Index :Int, card2Index: Int, card3Index: Int) {
        if (checkBounds(index: card1Index) &&
            checkBounds(index: card2Index) &&
            checkBounds(index: card3Index)) {
            
            //Check if two are same.
            cards[card1Index].isPlayed = true
            cards[card2Index].isPlayed = true
            cards[card3Index].isPlayed = true
        }
    }
    
    private func checkBounds(index :Int)->Bool {
        if index < 0 || index  >= cards.count {
            return false
        }
        return true
    }
    
//    This gives a set of the most recent 3 cards
//    dealt.
    func dealCards() ->(card1: Int, card2: Int, card3: Int) {
        
        var result = Set<Int>()
        
        repeat {
            if result.count == 3 {
                break
            }
            let randomIndex = cards.count.random()
            
            if !cards[randomIndex].cardIsDealt {
                result.insert(randomIndex)
                cards[randomIndex].cardIsDealt = true
            }
        } while (result.count != 3)
        
        return (result.popFirst()!, result.popFirst()!, result.popFirst()!)
    }
    
    func getCardAt(at: Int) ->Card? {
        return checkBounds(index: at) ? cards[at] : nil
    }
}

extension Int {
    func random() -> Int {
        if (self == 0) {
            return 0
        }
        else if (self < 0) {
            return -(Int(arc4random_uniform(UInt32(-self))))
        }
        return Int(arc4random_uniform(UInt32(self)))
    }
}
