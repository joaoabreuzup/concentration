//
//  ViewController.swift
//  Concentration
//
//  Created by João Jacó Santos Abreu on 21/01/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    struct ThemeModel {
        var chosenEmojis : [String]
        var chosenEmojisToRemoveRandomly: [String]
        var chosenColorTheme: UIColor
    }
    
    //MARK: PROPERTIES
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    private(set) var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    private var themeModel = ThemeModel(chosenEmojis: [], chosenEmojisToRemoveRandomly: [], chosenColorTheme: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
    
    private var emoji = [Card:String]()
    
    private  let secondsToDelay = 3.5
    
    //MARK: @IB PROPERTIES
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private weak var StartRestartButton: UIButton!
    
    @IBOutlet weak var scoreButton: UIButton!
    
    //MARK: FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        disableCards()
        adjustButtons()
        adjustLabels()
    }
    
    func setThemeModel(emojiThemeChoice: [String], chosenColorTheme: UIColor) {
        themeModel.chosenEmojis = emojiThemeChoice
        themeModel.chosenEmojisToRemoveRandomly = themeModel.chosenEmojis
        themeModel.chosenColorTheme = chosenColorTheme
    }
    
    private func shuffleWhenScreenshotIsTaken(){
        NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: OperationQueue.main) { notification in
            let alert = UIAlertController(title: "👮🏿‍♂️", message: "Nice screenshot. Let's shuffle this again...", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            self.game.shuffleCards()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToHighscore" {
            guard let controller = segue.destination as? HighscoreViewController else { return }
            controller.setPlayerFlipCount(flipCount: flipCount)
        }
    }
    
    
    private func showUpCards() {
        for indexOf in cardButtons.indices {
            let button = cardButtons[indexOf]
            let card = game.cards[indexOf]
            button.setTitle(emoji(for: card), for: UIControl.State.normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            button.isUserInteractionEnabled = false
        }
    }
    
    private func flipCardsUpsideDown() {
        for indexOf in cardButtons.indices {
            let button = cardButtons[indexOf]
            button.setTitle("", for: UIControl.State.normal)
            button.backgroundColor = themeModel.chosenColorTheme
            button.isUserInteractionEnabled = true
        }
    }
    
    private func previewCards() {
        showUpCards()
        shuffleWhenScreenshotIsTaken()
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
            self.flipCardsUpsideDown()
        }
    }
    
    private func adjustButtons() {
        for button in cardButtons {
            button.layer.cornerRadius = 5
        }
        StartRestartButton.layer.cornerRadius = 10
        scoreButton.layer.cornerRadius = 10
    }
    
    private func adjustLabels() {
        flipCountLabel.textColor = themeModel.chosenColorTheme
    }
    
    private func disableCards() {
        cardButtons.forEach() {
            $0.isUserInteractionEnabled = false
            $0.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    private func disableStartRestart() {
        StartRestartButton.isUserInteractionEnabled = false
        StartRestartButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        StartRestartButton.setTitle("Restart", for: UIControl.State.normal)
    }
    
    private func enableStartRestart() {
        StartRestartButton.isUserInteractionEnabled = true
        StartRestartButton.backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                if game.isGamefinished {
                    button.layer.isHidden = true
                    performSegue(withIdentifier: "goToHighscore", sender: self)
                }
            } else {
                button.setTitle("", for: UIControl.State.normal)
                if card.isMatched {
                    button.layer.isHidden = true
                } else {
                    button.backgroundColor = themeModel.chosenColorTheme
                }
                
            }
        }
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil , themeModel.chosenEmojisToRemoveRandomly.count > 0 {
            emoji[card] = themeModel.chosenEmojisToRemoveRandomly.remove(at: themeModel.chosenEmojisToRemoveRandomly.count.arc4random)
        }
        return emoji[card] ?? "?"
    }
    
    private func updateCount(indexOf cardNumber: Int) {
        var cardsFacedUp = 0
        for indexOfCards in cardButtons.indices {
            let card = game.cards[indexOfCards]
            if card.isFaceUp == true {
                cardsFacedUp+=1
            }
        }
        if !game.cards[cardNumber].isFaceUp || cardsFacedUp == 2 && !game.cards[cardNumber].isMatched{
            flipCount+=1
        }
    }
    
    //MARK: ACTIONS
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            updateCount(indexOf: cardNumber)
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
        
    }
    
    @IBAction private func StartRestart(_ sender: UIButton) {
        var _: [String]
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        themeModel.chosenEmojisToRemoveRandomly = themeModel.chosenEmojis
        cardButtons.forEach {
            $0.isUserInteractionEnabled = true
            $0.layer.isHidden = false
        }
        game.shuffleCards()
        updateViewFromModel()
        flipCount = 0
        previewCards()
        disableStartRestart()
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
            self.enableStartRestart()
        }
    }
    @IBAction func showHighscore(_ sender: UIButton) {
        guard let highScoreViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HighscoreViewController") as? HighscoreViewController else { return }
        present(highScoreViewController, animated: true)
        highScoreViewController.hideScoreLabelAndTextFieldToShowScore()
    }
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
