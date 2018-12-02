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
        
//        Score Label only needs one time initialization.
        scoreLabel.numberOfLines = 0
        
        scoreLabel.textColor = .orange
        scoreLabel.font = UIFont.systemFont(ofSize: UIFont.systemFontSize * 2 , weight: .bold)
        scoreLabel.adjustsFontSizeToFitWidth = true
        
//        Trigger Label Text display with value.
        score = 0
        
        //        Initialize the mapping array of at most 24 items.
        for mappingIndex in 0..<24 {
            cardIndextoGameIndex[mappingIndex] = SetGameVeiwConstants.NO_MAPPING
        }
        
        for _ in 0..<4 {
            addCardsToGameView()
        }
        addScoreAndNewGameButton()
    }
    
    private var game = SetGame() {
        didSet {
            //        Initialize the mapping array of at most 24 items.
            for mappingIndex in 0..<24 {
                cardIndextoGameIndex[mappingIndex] = SetGameVeiwConstants.NO_MAPPING
            }
            
            for _ in 0..<4 {
                addCardsToGameView()
            }
            addScoreAndNewGameButton()
        }
    }
    
    private var controlButtonsStackView = UIStackView()
    
    private var selectedCards = [Int]() {
        didSet {
            if selectedCards.count == 3 {
                let card1At = cardIndextoGameIndex[selectedCards[0]]!.gameCardIndex!
                let card2At = cardIndextoGameIndex[selectedCards[1]]!.gameCardIndex!
                let card3At = cardIndextoGameIndex[selectedCards[2]]!.gameCardIndex!
                
                if game.isASet(card1Index: card1At, card2Index: card2At, card3Index: card3At, withCallback: {_ in }) {
//                    Remove the mappings.
                    for mappingIndex in selectedCards {
                        cardIndextoGameIndex[mappingIndex] = SetGameVeiwConstants.NO_MAPPING
                    }
                    updateScore()
                    addCardsToGameView()
                    addScoreAndNewGameButton()
                }
//                We need to reset the borders now.
                for viewMapping in selectedCards {
                    let button = cardIndextoGameIndex[viewMapping]!.viewButton!
                    button.layer.borderWidth = 0.0
                    button.layer.borderColor = UIColor.white.cgColor
                }
//                Clean the selected cards.
                selectedCards.removeAll()
            }
            else {
//                Reset the borders of the deselected items.
                for viewMapping in oldValue {
                    let button = cardIndextoGameIndex[viewMapping]!.viewButton!
                    
                    if !selectedCards.contains(viewMapping) {
                        button.layer.borderWidth = 0.0
                        button.layer.borderColor = UIColor.white.cgColor
                    }
                }
//                Set the borders of the selected ones.
                
                for viewMapping in selectedCards {
                    let button = cardIndextoGameIndex[viewMapping]!.viewButton!
                    button.layer.borderWidth = 3.0
                    button.layer.borderColor = UIColor.orange.cgColor
                }
                
            }
        }
    }
    
    private func updateScore() {
        score += 1
    }
    
    private var scoreLabel = UILabel()
    private var score :Int = 0 {
        didSet {
            scoreLabel.text = "Score\n\(score)"
        }
    }
    
//    Possibly update the  UI whenever cardIndextoGameIndex is updated?
//    We can do this using getter/setter for the variable.
    private var cardIndextoGameIndex : [Int : ViewButtonToGameCard] = [:]
    
    private func addCardsToGameView() {
        let cards = game.dealCards()
        let arr = [cards.card1, cards.card2, cards.card3]
        var whichCard =  0
        for key in cardIndextoGameIndex.keys {
            if whichCard ==  3 {
                break
            }
            
            if cardIndextoGameIndex[key] == SetGameVeiwConstants.NO_MAPPING  {
                cardIndextoGameIndex[key] =
                    ViewButtonToGameCard(viewButton: nil, gameCardIndex: arr[whichCard], viewButtonIndex: key)
                whichCard += 1
            }
        }
        drawCardsOnUI()
    }
    
    private func drawCardsOnUI() {
        var count =  0
        var horizStackView = UIStackView()
        horizStackView.axis = .horizontal
        horizStackView.alignment = .fill
        horizStackView.distribution = .fillEqually
        horizStackView.spacing = 8
        
        for view in gameVerticalStackView.arrangedSubviews {
            gameVerticalStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for (mapIndex, cardIndex) in cardIndextoGameIndex    {
            
            if cardIndex == SetGameVeiwConstants.NO_MAPPING {
                continue
            }
            
            if (count == 3) {
                gameVerticalStackView.addArrangedSubview(horizStackView)
                horizStackView = UIStackView()
                horizStackView.axis = .horizontal
                horizStackView.alignment = .fill
                horizStackView.distribution = .fillEqually
                horizStackView.spacing = 8
                //                Reset Count to zero when we've added 3 cards.
                count = 0
            }
            
            let button = UIButton()
            cardIndextoGameIndex[mapIndex]?.viewButton = button
            
            button.setButtonTitle(game: game, cardIndex: cardIndex.gameCardIndex!)
            horizStackView.addArrangedSubview(button)
            //            horizStackView.backgroundColor = .orange
            button.backgroundColor = .white
            button.tag = mapIndex
            button.addTarget(self, action: #selector(ViewController.onCardSelected(button:)), for: .touchUpInside)
            count += 1
        }
        if count == 3{
            gameVerticalStackView.addArrangedSubview(horizStackView)
        }
    }
    
    private func addScoreAndNewGameButton() {
        let horizStackView = UIStackView()
        
        horizStackView.axis = .horizontal
        horizStackView.alignment = .fill
        horizStackView.distribution = .fillEqually
        horizStackView.spacing = 8
        horizStackView.backgroundColor = .white
        
        let newGameButton = UIButton()
        let dealMoreCardsButton = UIButton()
        
        newGameButton.setTitle("New\nGame", for: .normal)
        newGameButton.titleLabel?.adjustsFontSizeToFitWidth = true
        newGameButton.titleLabel?.font = UIFont.systemFont(ofSize: UIFont.systemFontSize  * 2, weight: .bold)
        newGameButton.titleLabel?.lineBreakMode = .byWordWrapping
        newGameButton.backgroundColor = .orange
        
        newGameButton.addTarget(self, action:
            #selector(ViewController.onNewGame(button:))
            , for: .touchUpInside)
        newGameButton.layer.cornerRadius = SetGameVeiwConstants.CARD_CORNER_RADIUS
        
        dealMoreCardsButton.setTitle("Deal\nCards", for: .normal)
        dealMoreCardsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        dealMoreCardsButton.titleLabel?.font =
            UIFont.systemFont(ofSize: UIFont.systemFontSize * 2, weight: .bold)
        
        dealMoreCardsButton.titleLabel?.lineBreakMode = .byWordWrapping
        dealMoreCardsButton.backgroundColor = .orange
        dealMoreCardsButton.layer.cornerRadius =
            SetGameVeiwConstants.CARD_CORNER_RADIUS
        
        dealMoreCardsButton.addTarget(self, action:
            #selector(ViewController.onDealMoreCards(button:))
            , for: .touchUpInside)
        
        horizStackView.addArrangedSubview(scoreLabel)
        horizStackView.addArrangedSubview(dealMoreCardsButton)
        horizStackView.addArrangedSubview(newGameButton)
        
        
        gameVerticalStackView.removeArrangedSubview(controlButtonsStackView)
        controlButtonsStackView.removeFromSuperview()
        
        controlButtonsStackView = horizStackView
        gameVerticalStackView.addArrangedSubview(horizStackView)
    }
    
    @IBAction private func onCardSelected(button : UIButton) {
        highlightSelectedButton(button)
    }
    
    @IBAction private func onDealMoreCards(button: UIButton) {
        addCardsToGameView()
        addScoreAndNewGameButton()
    }
    
    @IBAction private func onNewGame(button: UIButton) {
        game = SetGame()
        score = 0
    }
    
    private func highlightSelectedButton(_ button :UIButton) {
        if selectedCards.contains(button.tag) {
            selectedCards.removeAll(where:{
                return button.tag == $0
            }
            )
        } else {
            selectedCards.append(button.tag)
        }
     }
}

extension UIButton {
    func setButtonTitle(game: SetGame, cardIndex :Int) {
        
        var stringAttributes: [NSAttributedString.Key :Any]?
        
        var solidAttributes:[NSAttributedString.Key : Any] = [.strokeWidth: -SetGameVeiwConstants.CARD_STROKEWIDTH]
        
        var stripedAttributes:[NSAttributedString.Key: Any]  = [:]
        
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
            self.layer.cornerRadius = SetGameVeiwConstants.CARD_CORNER_RADIUS
        }
    }
}
