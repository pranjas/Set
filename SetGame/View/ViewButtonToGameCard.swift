//
//  ViewButtonToGameCard.swift
//  SetGame
//
//  Created by Pranay Kumar Srivastava on 02/12/18.
//  Copyright © 2018 Pranay Kumar Srivastava. All rights reserved.
//

import Foundation
import UIKit

struct ViewButtonToGameCard: Equatable {
    weak var viewButton: UIButton?
    var gameCardIndex: Int?
    var viewButtonIndex: Int?
    
    public static func == (exp1: ViewButtonToGameCard, exp2: ViewButtonToGameCard) -> Bool {
        return (exp1.viewButton == exp2.viewButton) &&
        (exp1.gameCardIndex == exp2.gameCardIndex) &&
        (exp1.viewButtonIndex == exp2.viewButtonIndex)
    }
}
