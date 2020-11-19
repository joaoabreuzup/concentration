//
//  HighscoreViewController.swift
//  Concentration
//
//  Created by João Jacó Santos Abreu on 29/01/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import UIKit

struct PlayerInfo {
    let name: String
    let score: Int
}

class HighscoreViewController: UIViewController {
    
    //MARK: PROPERTIES
    private struct defaultsPlayerInfo {
        static let firstPlaceNameKey = "firstPlaceNameKey"
        static let firstPlaceScoreKey = "firstPlaceScoreKey"
        
        static let secondPlaceNameKey = "secondPlaceNameKey"
        static let secondPlaceScoreKey = "secondPlaceScoreKey"
        
        static let thirdPlaceNameKey = "thirdPlaceNameKey"
        static let thirdPlaceScoreKey = "thirdPlaceScoreKey"
        
        static let fourthPlaceNameKey = "fourthPlaceNameKey"
        static let fourthPlaceScoreKey = "fourthPlaceScoreKey"
        
        static let fifthPlaceNameKey = "fifthPlaceNameKey"
        static let fifthPlaceScoreKey = "fifthPlaceScoreKey"
    }
    
    let defaults = UserDefaults.standard
    
    private var playerFlipCount = 0
    
    private var shouldEnterHighscore: Bool {
        playerFlipCount < model[4].score
    }
    
    private var model: [PlayerInfo] = [] {
        didSet {
            checkDefaultLabels()
            updateView()
        }
    }
    
    
    @IBOutlet weak var firstPlayer: UILabel!
    @IBOutlet weak var secondPlayer: UILabel!
    @IBOutlet weak var thirdPlayer: UILabel!
    @IBOutlet weak var fourthPlayer: UILabel!
    @IBOutlet weak var fifthPlayer: UILabel!
    @IBOutlet weak var playerScoreLabel: UILabel!
    @IBOutlet weak var playerNameTextField: UITextField!
    
    //MARK: FUNCTIONS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        playerNameTextField.delegate = self
        hideKeyboardWhenTappedAround()
        model = highscorePopulation()
        model = getHighScores()
        checkDefaultLabels()
        updateView()
    }
    
    private func highscorePopulation() -> [PlayerInfo]{
        var players = [PlayerInfo]()
        for _ in 0..<5 {
            players.append(PlayerInfo(name: "", score: 9999))
        }
        return players
    }
    
    private func checkDefaultLabels() {
        if model[0].score == 9999 {
            firstPlayer.text = "1º"
        }
        if model[1].score == 9999 {
            secondPlayer.text = "2º"
        }
        if model[2].score == 9999 {
            thirdPlayer.text = "3º"
        }
        if model[3].score == 9999 {
            fourthPlayer.text = "4º"
        }
        if model[4].score == 9999 {
            fifthPlayer.text = "5º"
        }
        if !shouldEnterHighscore {
            hideScoreLabelAndTextField()
        }
    }
    
    private func getHighScores() -> [PlayerInfo] {
        
        guard let first = getPlayerInfo(nameKey: defaultsPlayerInfo.firstPlaceNameKey, scoreKey: defaultsPlayerInfo.firstPlaceScoreKey),
            let second = getPlayerInfo(nameKey: defaultsPlayerInfo.secondPlaceNameKey, scoreKey: defaultsPlayerInfo.secondPlaceScoreKey),
            let third = getPlayerInfo(nameKey: defaultsPlayerInfo.thirdPlaceNameKey, scoreKey: defaultsPlayerInfo.thirdPlaceScoreKey),
            let fourth = getPlayerInfo(nameKey: defaultsPlayerInfo.fourthPlaceNameKey, scoreKey: defaultsPlayerInfo.fourthPlaceScoreKey),
            let fifth = getPlayerInfo(nameKey: defaultsPlayerInfo.fifthPlaceNameKey, scoreKey: defaultsPlayerInfo.fifthPlaceScoreKey) else { return model}
        
        let array = [first,second,third,fourth,fifth]
        return array
    }
    
    private func getPlayerInfo(nameKey: String, scoreKey: String) -> PlayerInfo? {
        guard let firtsScoreName = defaults.string(forKey: nameKey) else {
            return nil
        }
        let firstScoreNumber = defaults.integer(forKey: scoreKey)
        let score = PlayerInfo(name: firtsScoreName, score: firstScoreNumber)
        
        return score
    }
    
    private func updateView() {
        firstPlayer.text = "1º \(model[0].name): \(model[0].score)"
        secondPlayer.text = "2º \(model[1].name): \(model[1].score)"
        thirdPlayer.text = "3º \(model[2].name): \(model[2].score)"
        fourthPlayer.text = "4º \(model[3].name): \(model[3].score)"
        fifthPlayer.text = "5º \(model[4].name): \(model[4].score)"
        checkDefaultLabels()
    }
    
    func setHighscore(){
        
        let playerScore = playerFlipCount
        let playerNameValue = playerNameTextField.text
        playerNameTextField.isHidden = true
        model.insert(PlayerInfo(name: playerNameValue ?? "", score: playerScore), at: 0)
        model.sort(by: {$0.score < $1.score})
        saveHighscore()
        
    }
    
    func saveHighscore(){
        
        defaults.set(model[0].name, forKey: defaultsPlayerInfo.firstPlaceNameKey)
        defaults.set(model[0].score, forKey: defaultsPlayerInfo.firstPlaceScoreKey)
        
        defaults.set(model[1].name, forKey: defaultsPlayerInfo.secondPlaceNameKey)
        defaults.set(model[1].score, forKey: defaultsPlayerInfo.secondPlaceScoreKey)
        
        defaults.set(model[2].name, forKey: defaultsPlayerInfo.thirdPlaceNameKey)
        defaults.set(model[2].score, forKey: defaultsPlayerInfo.thirdPlaceScoreKey)
        
        defaults.set(model[3].name, forKey: defaultsPlayerInfo.fourthPlaceNameKey)
        defaults.set(model[3].score, forKey: defaultsPlayerInfo.fourthPlaceScoreKey)
        
        defaults.set(model[4].name, forKey: defaultsPlayerInfo.fifthPlaceNameKey)
        defaults.set(model[4].score, forKey: defaultsPlayerInfo.fifthPlaceScoreKey)
        
    }
    
    func setPlayerFlipCount(flipCount: Int) {
        playerFlipCount = flipCount
    }
    
    func hideScoreLabelAndTextField() {
        playerNameTextField.isHidden = true
        playerScoreLabel.text = "Your score: \(playerFlipCount)"
    }
    
    func hideScoreLabelAndTextFieldToShowScore() {
        playerNameTextField.isHidden = true
        if playerFlipCount != 0 {
            playerScoreLabel.text = "Your score: \(playerFlipCount)"
        }else {
            playerScoreLabel.text = "Keep trying."
        }
    }
}

extension HighscoreViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        setHighscore()
        playerNameTextField.isUserInteractionEnabled = false
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: false, moveValue: 253)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 10
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 253)
    }
    
    func animateViewMoving(up: Bool, moveValue: CGFloat){
        let movement:CGFloat = (up ? -moveValue : moveValue)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        }, completion: nil)
    }
}


