//
//  SetGameViewConstants.swift
//  SetGame
//
//  Created by Pranay Kumar Srivastava on 28/11/18.
//  Copyright © 2018 Pranay Kumar Srivastava. All rights reserved.
//

import Foundation
import UIKit

class SetGameVeiwConstants {
    static let SYMBOL_TRIANGLE = "▲"
    static let SYMBOL_CIRCLE = "●"
    static let SYMBOL_SQUARE = "■"
    
    static let CARD_COLOR = UIColor.orange
    static let CARD_STROKEWIDTH = 10
    
    static let CARD_CORNER_RADIUS = 8.0
    
    static let cardColor: [Card.Color: UIColor] =
        [.BLUE : .blue , .RED: .red, .GREEN : .green]
    
    public static func getStringForCard(_ card: Card)->String {
        
        switch card.symbol {
        case .DIAMOND:
            return SetGameVeiwConstants.SYMBOL_TRIANGLE
        case .CIRCLE:
            return SetGameVeiwConstants.SYMBOL_CIRCLE
        case .SQUARE:
            return SetGameVeiwConstants.SYMBOL_SQUARE
        }
    }
}
