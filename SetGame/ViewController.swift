//
//  ViewController.swift
//  SetGame
//
//  Created by Pranay Kumar Srivastava on 24/11/18.
//  Copyright © 2018 Pranay Kumar Srivastava. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var gameVerticalStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        gameVerticalStackView.backgroundColor = .orange
        for _ in 0..<4 {
            addCardsToGameView()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    private let game = SetGame()
    private var cardsInPlay = [UIButton]()
    
    //    Maps the index in UI to index in the Game.
    private var cardMapping = [Int:Int] ()
    
    private func addCardsToGameView() {
        let cards = game.dealCards()
        let arr = [cards.card1, cards.card2, cards.card3]
        let horizStackView = UIStackView()
        
        horizStackView.axis = .horizontal
        horizStackView.alignment = .fill
        horizStackView.distribution = .fillEqually
        horizStackView.spacing = 8
        
        
        for cardIndex in arr {
            let button = UIButton()
            button.setButtonTitle(game: game, cardIndex: cardIndex)
            horizStackView.addArrangedSubview(button)
//            horizStackView.backgroundColor = .orange
            button.backgroundColor = .white
        }
        gameVerticalStackView.addArrangedSubview(horizStackView)
    }
}

extension UIButton {
    func setButtonTitle(game: SetGame, cardIndex :Int) {
        
        var stringAttributes: [NSAttributedString.Key :Any]?
        
        var solidAttributes:[NSAttributedString.Key : Any] = [.strokeWidth: -SetGameVeiwConstants.CARD_STROKEWIDTH]
        
        var stripedAttributes:[NSAttributedString.Key: Any]  = [:
//            .strokeWidth: SetGameVeiwConstants.CARD_STROKEWIDTH
        ]
        
        var outlineAttributes : [NSAttributedString.Key : Any]
            = [:]
        
        if let card = game.getCardAt(at: cardIndex) {
            switch(card.shading) {
                
            case .NONE:
                outlineAttributes[.foregroundColor] = SetGameVeiwConstants.cardColor[card.color]
                
                outlineAttributes[.strokeWidth] = SetGameVeiwConstants.CARD_STROKEWIDTH
                stringAttributes = outlineAttributes
                
            case .SOLID:
                solidAttributes[.foregroundColor] = SetGameVeiwConstants.cardColor[card.color]
                stringAttributes = solidAttributes
                
            case .STRIPES:
                stripedAttributes[.foregroundColor] = SetGameVeiwConstants.cardColor[card.color]?.withAlphaComponent(0.15)
                stringAttributes = stripedAttributes
            }
            
            var cardString = SetGameVeiwConstants.getStringForCard(card)
            
            for _ in 0..<card.number - 1 {
                cardString += "\n"
                cardString += SetGameVeiwConstants.getStringForCard(card)
            }
            let attributedString =  NSAttributedString(string: cardString, attributes: stringAttributes!)
            self.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize * 2, weight: .bold)
            self.titleLabel?.lineBreakMode = .byWordWrapping
            self.setAttributedTitle(attributedString, for: .normal)
            self.layer.cornerRadius = CGFloat(SetGameVeiwConstants.CARD_CORNER_RADIUS)
        }
    }
}
