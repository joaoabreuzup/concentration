//
//  ThemeViewController.swift
//  Concentration
//
//  Created by João Jacó Santos Abreu on 01/02/20.
//  Copyright © 2020 João Jacó Santos Abreu. All rights reserved.
//

import UIKit

class ThemeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationBar.barStyle = .default
        navigationBar.isTranslucent = false
        
    }
    //MARK: PROPERTIES
    
    @IBOutlet weak var HallowenThemeButton: UIButton!
    
    @IBOutlet weak var AnimalsThemeButton: UIButton!
    
    
    //MARK: FUNCTIONS
    
    private func showMainGameScreen(emojiThemeChoice: [String], chosenColorTheme: UIColor) {
        if let vc = self.storyboard?.instantiateViewController(identifier: "gameScreen") as? ViewController {
            vc.setThemeModel(emojiThemeChoice: emojiThemeChoice, chosenColorTheme: chosenColorTheme)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    
    //MARK: ACTIONS
    
    @IBAction func pickHallowenTheme(_ sender: UIButton) {
        let emojiHallowenTheme = ["🎃","👻","😱","🦇","😈","🍭","🍎","🙀","🍬","👹","💀","🧛🏻‍♂️"]
        let chosenHallowenColorTheme = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        showMainGameScreen(emojiThemeChoice: emojiHallowenTheme, chosenColorTheme: chosenHallowenColorTheme)
    }
    
    @IBAction func pickAnimalsTheme(_ sender: UIButton) {
        let emojiAnimalsTheme = ["🐶","🐱","🐭","🐰","🐵","🐸","🦐","🐳","🦁","🐞","🦀","🐼"]
        let chosenAnimalsColorTheme = #colorLiteral(red: 0, green: 0.7994195819, blue: 0.2791521251, alpha: 1)
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        showMainGameScreen(emojiThemeChoice: emojiAnimalsTheme, chosenColorTheme: chosenAnimalsColorTheme)
    }
    
}
