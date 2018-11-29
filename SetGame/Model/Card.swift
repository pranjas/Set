//
//  Card.swift
//  SetGame
//
//  Created by Pranay Kumar Srivastava on 24/11/18.
//  Copyright © 2018 Pranay Kumar Srivastava. All rights reserved.
//

import Foundation

struct Card{
    
    enum Color:Int, CaseIterable {
        case RED  = 0
        case GREEN
        case BLUE
    }
    
    enum Shading:Int, CaseIterable {
        case SOLID = 0
        case STRIPES
//      None is just a boundary.
        case NONE
    }
    
    enum Symbol:Int, CaseIterable {
        case DIAMOND  = 0
        case SQUARE
        case CIRCLE
    }
    
    var color: Color
    var number: Int
    var shading: Shading
    var symbol: Symbol
    var isPlayed: Bool
    var cardIsDealt : Bool
}

extension Card {
    func hasDifferentColor(card: Card) -> Bool {
        return self.color != card.color
    }
    
    func hasDifferentSymbol(card: Card)  ->Bool {
        return self.symbol != card.symbol
    }
    
    func hasDifferentNumber(card: Card) -> Bool {
        return self.number != card.number
    }
    
    func hasDifferentShading(card: Card) -> Bool {
        return self.shading != card.shading
    }
    
    func isASetWithPair(card1 :Card, card2 :Card) ->Bool {
        
        var result = false
        
        //All are different colors.
        result = card1.hasDifferentColor(card: card2) && self.hasDifferentColor(card: card2) && self.hasDifferentColor(card: card1)
        
//        Check if all colors are same.
        if !result {
            result = !card1.hasDifferentColor(card: card2) && (!self.hasDifferentColor(card: card2)) && (!self.hasDifferentColor(card: card1))
        }
        
        if (result) {
//            Either all are same color or all are of
//            different color at this time.
            
            result = card1.hasDifferentSymbol(card: card2) && self.hasDifferentShading(card: card1) && self.hasDifferentSymbol(card: card2)
            
//            All  are not same symbols
            if (!result) {
                result = !card1.hasDifferentSymbol(card: card2) && !self.hasDifferentShading(card: card1) && !self.hasDifferentSymbol(card: card2)
            }
        }
      
        if (result) {
//            At this point we've different colors and  symbols
            
            result = card1.hasDifferentNumber(card: card2) &&
            self.hasDifferentNumber(card: card2) &&
            self.hasDifferentNumber(card: card1)
            
            if !result {
                result = !card1.hasDifferentNumber(card: card2) &&
                    !self.hasDifferentNumber(card: card2) &&
                    !self.hasDifferentNumber(card: card1)
            }
        }
        
        if result {
            result = card1.hasDifferentShading(card: card2) && self.hasDifferentShading(card: card1)
            && self.hasDifferentShading(card: card2)
            
            if !result {
                result = !card1.hasDifferentShading(card: card2) && !self.hasDifferentShading(card: card1)
                    && !self.hasDifferentShading(card: card2)
                
            }
        }
        return result
    }
}

