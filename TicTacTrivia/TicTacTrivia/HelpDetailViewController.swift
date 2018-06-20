//
//  HelpDetailViewController.swift
//  TicTacTrivia
//
//  Created by nijo on 04/04/2018.
//  Copyright © 2018 Nijo. All rights reserved.
//

import UIKit

class HelpDetailViewController: UIViewController {

    //@IBOutlet weak var DetailLabel: UINavigationItem!
    //@IBOutlet weak var navigationbar: UINavigationBar!
    
    @IBOutlet weak var lblDetailTitle: UILabel!
    @IBOutlet weak var helpDetails: UITextView!
    var pass_str: String?
    
    @IBOutlet weak var imageDetail: UIImageView!
    var imageList = ["menuD.jpg","rulesD.jpg","triviaD.jpg","tieD.png","aiD.jpg","settingsD.png","creditsD.jpg"]
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    override func viewWillLayoutSubviews() {
        lblDetailTitle.sizeToFit()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareNavBar(){
        //navigationbar.barTintColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0)
        //navigationbar.barStyle = UIBarStyle.black
        //DetailLabel.title = pass_str
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        statusBar?.backgroundColor = UIColor.clear
        lblDetailTitle.text = pass_str
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func prepareView(){
        prepareNavBar()
        var image = ""
       
        switch pass_str {
        case "Menu"?:
            image = imageList[0]
            helpDetails.text = "The main menu allows users to select different game modes: single player or multiplayer.\n\nSingle player mode: in this mode the user plays against an AI whose level can be set to low, medium, high.\n\nMultiplayer mode: in this mode the user can choose to play against other players either locally on the same device or over different devices connected through the network."
        case "Rules"?:
            image = imageList[1]
            helpDetails.text = "This turn-by-turn game is loosely based on tic tac toe mechanics. However there are some key differences.\n\nThe goal is to get 4 symbols in a row (not 3) on the 4x4 grid (instead of a regular 3x3 grid).\n\nEach player needs to correctly answer a random trivia question in order to validate his move.\n\nIf the answer is wrong, the player cannot finish his move and thus skips his turn."
        case "Trivia"?:
            image = imageList[2]
            helpDetails.text = "At each move players will be required to answer a random trivia question.\n\nThe question are directly fetched from the OpenTriviaDB open source project and are pulled at every game session in order to avoid repeated questions.\n\nThe questions are posed as multiple choices, as such the player needs to choose the correct answer within a limited time frame.\n\nIf no answer is chosen the player will skip his turn. The difficulty of the trivia questions can be set in the game settings before the game session begins."
        case "Tie-Breaker"?:
            image = imageList[3]
             helpDetails.text = "In the multiplayer mode, if the game ends in a tie a 'tie breaker' mode is made available in order to select a winner.\n\nThis mode is optional and players can choose to end the game in a draw. The tie breaker is a characterised by a ripid-fire session of random true-or-false trivia questions.\n\nThe player will the highest number of correct answer out of the initial 5 question will be considered the winner.\n\nIf both players have the same amount of correct answers this will go on until one player loses."
        case "AI"?:
            image = imageList[4]
             helpDetails.text = "In single player mode the player is put against an AI.\n\nThe AI is a basic rules-based engine with 3 degrees of intelligence.\n\nThe basic level makes random moves.\n\nThe mid-level ai attacks and defends while the high-level attacks more aggressively."
            
        case "Settings"?:
            image = imageList[5]
             helpDetails.text = "Several game parameters can be customised.\n\nThe gameplay theme can be changed.\n\nSound effects can be switched on/off.\n\nPlayer names can be easily set before the game session starts,\n\nAi level can be set before the game sessions as well,\n\nTrivia question's difficulty level can be set in the settings page."
            
        case "Credits"?:
            image = imageList[6]
            helpDetails.text = "PixelTail Games for OpenTriviaDB database,\n\nFonticons for FontAwesome fonts,\n\nIcons8 for iOS Glitch icons."
        default:
            break
        }
        imageDetail.image = UIImage(named: image)
    }

}
