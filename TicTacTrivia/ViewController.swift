//
//  ViewController.swift
//  TicTacTrivia
//
//  Created by nijo on 28/03/2018.
//  Copyright © 2018 Nijo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var progress: KDCircularProgress!
    
    var currentCount:Double = 0
    var stepSize:Double = 360
    var maxCount:Double = 360
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.string(forKey: key) != nil
    }
    
    func setUserDefaults(){
        
        //if (isKeyPresentInUserDefaults(key: "userName")){
            let p1Name = "Player1"
            let p2Name = "Player2"
            let aiLevel = 1
            let userSymbol = 1
            let triviaLevel = 0
            let soundEffects = 1
            let theme = 3
            let p1Wins = 0
            let p2Wins = 0
            let gameMode = 1
            let bMusic = 1
            let roundPlayed = 0
        
            // Save Settings
            UserDefaults.standard.set(p1Name, forKey: "p1Name")
            UserDefaults.standard.set(p2Name, forKey: "p2Name")
            UserDefaults.standard.set(aiLevel, forKey: "aiLevel")
            UserDefaults.standard.set(userSymbol, forKey: "userSymbol")
            UserDefaults.standard.set(triviaLevel, forKey: "triviaLevel")
            UserDefaults.standard.set(soundEffects, forKey: "soundEffects")
            UserDefaults.standard.set(theme, forKey: "theme")
            UserDefaults.standard.set(p1Wins, forKey: "p1Wins")
            UserDefaults.standard.set(p2Wins, forKey: "p2Wins")
            UserDefaults.standard.set(p2Wins, forKey: "p2Wins")
            UserDefaults.standard.set(gameMode, forKey: "gameMode")
            UserDefaults.standard.set(bMusic, forKey: "bgMusic")
            UserDefaults.standard.set(roundPlayed, forKey: "roundsPlayed")
       //}
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(progress)
        setUserDefaults()
        progress.animate(fromAngle: 0,toAngle: maxCount, duration: 5.0) { completed in
            if completed {
                DispatchQueue.main.async() {
                    [unowned self] in
                    self.performSegue(withIdentifier: "mainSegue", sender: self)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
}

