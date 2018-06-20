//
//  GameSessionViewController.swift
//  TicTacTrivia
//
//  Created by nijo on 29/03/2018.
//  Copyright © 2018 Nijo. All rights reserved.
//

import UIKit
import AVFoundation

class GameSessionViewController: UIViewController {
    @IBOutlet weak var pauseBtn: UIButton!
    
    @IBOutlet weak var gridImage: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var soundBtn: UIButton!
    @IBOutlet weak var soundOffBtn: UIButton!
    
    @IBOutlet weak var p1Label: UILabel!
    @IBOutlet weak var p2Label: UILabel!
    
    @IBOutlet weak var messageBoard: UILabel!
    
    @IBOutlet weak var imgP1Symbol: UIImageView!
    @IBOutlet weak var imgP2Symbol: UIImageView!
    
    @IBOutlet weak var vsImage: UIImageView!
    @IBOutlet weak var lblP1Score: UILabel!
    @IBOutlet weak var lblP2Score: UILabel!
    @IBOutlet weak var lblScoreDiv: UILabel!
    
    @IBOutlet weak var helpBtn: UIButton!
    
    @IBOutlet weak var homeBtn: UIButton!
    
    var p1SymbolFlag = 0
    
    var timer = Timer()
    
    var questionsArray : [NSDictionary]!
    var tieBreakArray : [NSDictionary]!
    
    var gameMove : Array<String> = []
    
    var tieBreakParse : [[String]] = []
    
    var singleQuestion : [String] = []
    
    var audioPlayer: AVAudioPlayer?
    
    var position = -1
    
    var isADraw = false
    
    var passivePlayer = 0
    
    var localPlayer = 0
    
    var onlinePlayer = 0
    
    var sessionID = 0
    
    var onlineMove = -1
    
    var prevOnlineMove = -10
    
    var onlineTimer = Timer()
    
    var isOnlineMoveCompleted:Bool = false
    
    var skippedTurnsOnline = 0
    
    //Array represents each position within the grid
    var gameState = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    //Set the winning states
    let winningCombinations = [[0,1,2,3], [4,5,6,7], [8,9,10,11], [12,13,14,15], [0,4,8,12], [1,5,9,13], [2,6,10,14], [3,7,11,15],[0,5,10,15],[3,6,9,12]]
    //Set game activity
    var gameActive = true
    //Sets the current player
    var activePlayer = 1
    //Remaining moves
    var remainingMoves = 16
    
    var theme = 0
    
    var gameMode = 1
    
    var aiLevel = 1
    
    var sBackground = true
    
    var sEffects = 0
    
    var p1Name = "Player 1"
    
    var p2Name = "AI"
    
    var trivia = false
    
    var questionCounter = 0
    
    var tempTag:Int = 0
    
    var aiTurn = false
    
    var onlineTurn = false
    
    var p1symbol = "crossMin.png"
    
    var p2symbol = "circleMin.png"
    
    var tieBreakWinner = 0
    
    var netID = 0
    
    @IBAction func soundButton(_ sender: UIButton) {
        
        player?.stop()
        soundOffBtn.isHidden = false
        soundBtn.isHidden = true
        UserDefaults.standard.set(0, forKey: "bgMusic")
        
    }
    
    @IBAction func soundButtonOff(_ sender: UIButton) {
        
        player?.play()
        soundOffBtn.isHidden = true
        soundBtn.isHidden = false
        UserDefaults.standard.set(1, forKey: "bgMusic")
        
    }
    
    @IBAction func homeButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Back to Main Menu", message: "Are you sure you want to quit the game?", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in self.quitOnlineGame()}))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in self.startTimer()}))

        alert.view.tintColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0)
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func quitOnlineGame(){
        setGameMove(position: -999)
        UserDefaults.standard.set(0, forKey: "roundsPlayed")
        UserDefaults.standard.set(0, forKey: "p2Wins")
        UserDefaults.standard.set(0, forKey: "p2Wins")
        UserDefaults.standard.set(0, forKey: "onlineStatus")
        DispatchQueue.main.async() {
            [unowned self] in
            self.performSegue(withIdentifier: "backtoMenuUnwindSegue", sender: self)
        }
    }
    
    func connectionLost(){
        if localPlayer == 1{
            messageBoard.text = p1Name + " won!"
            
        } else{
            messageBoard.text = p2Name + " won!"
        }
        let alert = UIAlertController(title: "Enemy Defeated!", message: "The opponent has prematurely surrendered! You won this battle!", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Woohoo!!!", style: .default, handler: { action in self.enemySurrender()}))
        
        alert.view.tintColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0)
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //All 9 buttons connected to the same 'action'
    @IBAction func action(_ sender: Any) {
        //Check if the gameActivity is active (no one has won!)
        if(gameActive == true){
            //Check if the grid square has been already been set
            if (gameMode == 1){
                if (gameState[(sender as AnyObject).tag-1] == 0) {
                tempTag = (sender as AnyObject).tag
                self.view?.isUserInteractionEnabled = false
                aiTurn = true
                triviaResult()
                //for testing:
//                stopTimer()
//                makeMove()
                // - end for testing
                    
                }
            } else if (gameMode == 2){
                if (gameState[(sender as AnyObject).tag-1] == 0) {
                    tempTag = (sender as AnyObject).tag
                    // uncomment for quiz
                    triviaResult()
                    //for testing:
//                    stopTimer()
//                    makeMove()
                    // - end for testing
                }
            } else if (gameMode == 3){
                if (gameState[(sender as AnyObject).tag-1] == 0) {
                    tempTag = (sender as AnyObject).tag
                    self.view?.isUserInteractionEnabled = false
                    onlineTurn = true
                    triviaResult()
                    //for testing:
//                        stopTimer()
//                        makeMove()
                    // - end for testing
                    
                }
            }
            
        }
    }
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        timer.invalidate()
        DispatchQueue.main.async() {
            [unowned self] in
            self.performSegue(withIdentifier: "gameToHelpSegue", sender: self)
        }
    
    }
    
    func getGameMove(){
        let queryPathURL = "http://localhost/getGameMove.php?id="+String(sessionID)
        // Asynchronous Http call to your api url, using URLSession:
        let request = URL(string: queryPathURL)!
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if error != nil
            {
                print ("ERROR")
            }
            else
            {
                if let content = data
                {
                    
                    do
                    {
                        let jsonResult = try JSONSerialization.jsonObject(with: content, options: .mutableContainers) as! NSArray
                        let tempArray = jsonResult.value(forKey: "positionP"+String(self.onlinePlayer)) as! Array<String>
                        let pos = Int(tempArray[0])!
                        if (pos != self.prevOnlineMove) {
                            self.onlineMove = pos
                            self.isOnlineMoveCompleted = true
                        }
                    }
                    catch
                    {
                    }
                }
            }
        }
        task.resume();
    
    }
    
    func setGameMove(position: Int){
        let queryPathURL = "http://localhost/setGameMove.php?player=positionP"+String(localPlayer)+"&position="+String(position)+"&id="+String(sessionID)
        let request = URL(string: queryPathURL)!
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if error != nil
            {
                print ("ERROR")
            }
            else
            {
                if let content = data
                {
                    
                    do
                    {
                        let jsonResult = try JSONSerialization.jsonObject(with: content, options: .mutableContainers) as! NSArray
                        
                        print(jsonResult)
                    }
                    catch
                    {
                    }
                }
            }
        }
        task.resume();
    }
    
    func makeOnlineMove(){
        stopTimer()
        onlineTurn = false
        view?.isUserInteractionEnabled = true
        prevOnlineMove = onlineMove
        if onlineMove < 0 {
            if onlineMove == -999 {
                connectionLost()
            } else {
                switchTurn()
            }
        } else {
            tempTag = onlineMove + 1
            gameState[tempTag - 1] = activePlayer
            let button = self.view.viewWithTag(tempTag) as! UIButton
            if activePlayer == 1 {
                button.setImage(UIImage(named:p1symbol), for: UIControlState())
            } else {
                button.setImage(UIImage(named:p2symbol), for: UIControlState())
            }
            popDrop()
            remainingMoves -= 1
            checkForWinner()
            checkForDraw()
            if (gameActive){
                switchTurn()
            }
        }
    }

    
    @objc func checkOpponentMove(){
        getGameMove()
        // do second task if success
        if isOnlineMoveCompleted {
            isOnlineMoveCompleted = false
            makeOnlineMove()
        }
    }
    
    func startOnlineTimer(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.onlineTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameSessionViewController.checkOpponentMove), userInfo: nil, repeats: true)
        }
    }
    
    func stopOnlineTimer(){
        onlineTimer.invalidate();
        onlineTimer = Timer();
    }
    
    func getTheme(){
        if theme == 0 {
            p1symbol = "crossMin.png"
            p2symbol = "circleMin.png"
            
        } else if theme == 1 {
            p1symbol = "triangleGeo.png"
            p2symbol = "circleGeo.png"
        } else if theme == 2 {
            p1symbol = "cross.png"
            p2symbol = "circle.png"
            //gridImage.image = UIImage(named: "grid.png")
        } else {
            p1symbol = "brain.png"
            p2symbol = "zombie.png"
        }
    }
    
    func getGameParameters(){
        p1SymbolFlag = UserDefaults.standard.integer(forKey: "userSymbol")
        theme = UserDefaults.standard.integer(forKey: "theme")
        gameMode = UserDefaults.standard.integer(forKey: "gameMode")
        aiLevel = UserDefaults.standard.integer(forKey: "aiLevel")
        p1Name = UserDefaults.standard.string(forKey: "p1Name")!
        p2Name = UserDefaults.standard.string(forKey: "p2Name")!
        sEffects = UserDefaults.standard.integer(forKey:"soundEffects")
        netID = UserDefaults.standard.integer(forKey: "netID")
        if gameMode == 3 {
            sessionID = UserDefaults.standard.integer(forKey: "sessionID")
            localPlayer = UserDefaults.standard.integer(forKey: "onlineStatus")
            if localPlayer == 1 {
                onlinePlayer = 2
            } else {
                onlinePlayer = 1
            }
        }
        
    }
    
    func assignSymbols(){
        if (p1SymbolFlag == 1){
            let temp = p1symbol
            p1symbol = p2symbol
            p2symbol = temp
        }
        imgP1Symbol.image = UIImage(named:p1symbol)
        imgP2Symbol.image = UIImage(named:p2symbol)
    }
    
    func makeMoveAI(){
        stopTimer()
        var selection = -1;
        if (aiLevel == 0){
            selection = aiEasyMove()
        } else if (aiLevel == 1){
            selection = aiMediumMove()
            if selection == -1 {selection = aiEasyMove()}
        } else {
            selection = aiMediumMove()
            if selection == -1 {selection = aiHardMove()}
            if selection == -1 {selection = aiEasyMove()}
            
        }
        gameState[selection] = activePlayer
        let button = view.viewWithTag(selection + 1) as! UIButton
        button.setImage(UIImage(named:p2symbol), for: UIControlState())
        popDrop()
        remainingMoves -= 1
        checkForWinner()
        checkForDraw()
        aiTurn = false
        //self.makeMove()
        self.view?.isUserInteractionEnabled = true
        if (gameActive){
            switchTurn()
        }
        
    }
    
    func aiEasyMove() -> Int{
        var selection = Int(arc4random_uniform(16));
        while (gameState[selection] != 0){
            selection = Int(arc4random_uniform(16));
        }
        return selection
    }
    
    
    func aiMediumMove() -> Int{
        // The ai uses some of the prioritized rules from https://en.wikipedia.org/wiki/Tic-tac-toe#Strategy:
        // 1. If there is a chance to win, go there.
        // 2. If there is a chance to block, go there.
        // 3. Empty center.
        // 4. If the opponent is in the corner, the play in the opposite corner.
        // 5. Empty corner.
        // 6. Empty side.
        
        passivePlayer = 0
        if activePlayer == 1 {passivePlayer = 2 } else {passivePlayer = 1}

        // case 1: if there is a chance to win
        if (gameState[0] == 0 && ((gameState[1] == activePlayer && gameState[1] == gameState[2] && gameState[2] == gameState[3]) || (gameState[4] == activePlayer && gameState[4] == gameState[8] && gameState[8] == gameState[12]) || (gameState[5] == activePlayer && gameState[5] == gameState[10] && gameState[10] == gameState[15]))){ return 0}
        else if (gameState[1] == 0 && ((gameState[0] == activePlayer && gameState[0] == gameState[2] && gameState[2] == gameState[3]) || (gameState[5] == activePlayer && gameState[5] == gameState[9] && gameState[9] == gameState[13]))){ return 1}
        else if (gameState[2] == 0 && ((gameState[0] == activePlayer && gameState[0] == gameState[1] && gameState[1] == gameState[3]) || (gameState[6] == activePlayer && gameState[6] == gameState[10] && gameState[10] == gameState[14]))){ return 2}
        else if (gameState[3] == 0 && ((gameState[0] == activePlayer && gameState[0] == gameState[1] && gameState[1] == gameState[2]) || (gameState[7] == activePlayer && gameState[7] == gameState[11] && gameState[11] == gameState[15]) || (gameState[6] == activePlayer && gameState[6] == gameState[9] && gameState[9] == gameState[12]) )){ return 3}
            
        else if (gameState[4] == 0 && ((gameState[5] == activePlayer && gameState[5] == gameState[6] && gameState[6] == gameState[7]) || (gameState[0] == activePlayer && gameState[0] == gameState[8] && gameState[8] == gameState[12]))){ return 4}
        else if (gameState[5] == 0 && ((gameState[4] == activePlayer && gameState[4] == gameState[6] && gameState[6] == gameState[7]) || (gameState[1] == activePlayer && gameState[1] == gameState[9] && gameState[9] == gameState[13]) || (gameState[0] == activePlayer && gameState[0] == gameState[10] && gameState[10] == gameState[15]))){ return 5}
        else if (gameState[6] == 0 && ((gameState[4] == activePlayer && gameState[4] == gameState[5] && gameState[5] == gameState[7]) || (gameState[2] == activePlayer && gameState[2] == gameState[10] && gameState[10] == gameState[14]) || (gameState[3] == activePlayer && gameState[3] == gameState[9] && gameState[9] == gameState[12])) ){ return 6}
        else if (gameState[7] == 0 && ((gameState[4] == activePlayer && gameState[4] == gameState[5] && gameState[5] == gameState[6]) || (gameState[3] == activePlayer && gameState[3] == gameState[11] && gameState[11] == gameState[15]))){ return 7}
        
        else if (gameState[8] == 0 && ((gameState[9] == activePlayer && gameState[9] == gameState[10] && gameState[10] == gameState[11]) || (gameState[0] == activePlayer && gameState[0] == gameState[4] && gameState[4] == gameState[12]))){ return 8}
        else if (gameState[9] == 0 && ((gameState[8] == activePlayer && gameState[8] == gameState[10] && gameState[10] == gameState[11]) || (gameState[1] == activePlayer && gameState[1] == gameState[5] && gameState[5] == gameState[13]) || (gameState[3] == activePlayer && gameState[3] == gameState[6] && gameState[6] == gameState[12]))){ return 9}
        else if (gameState[10] == 0 && ((gameState[8] == activePlayer && gameState[8] == gameState[9] && gameState[9] == gameState[11]) || (gameState[2] == activePlayer && gameState[2] == gameState[6] && gameState[6] == gameState[14]) || (gameState[0] == activePlayer && gameState[0] == gameState[5] && gameState[5] == gameState[15]))){ return 10}
        else if (gameState[11] == 0 && ((gameState[8] == activePlayer && gameState[8] == gameState[9] && gameState[9] == gameState[10]) || (gameState[3] == activePlayer && gameState[3] == gameState[7] && gameState[7] == gameState[15]))){ return 11}
        
        else if (gameState[12] == 0 && ((gameState[13] == activePlayer && gameState[13] == gameState[14] && gameState[14] == gameState[15]) || (gameState[0] == activePlayer && gameState[0] == gameState[4] && gameState[4] == gameState[8]) || (gameState[3] == activePlayer && gameState[3] == gameState[6] && gameState[6] == gameState[9]))){ return 12}
        else if (gameState[13] == 0 && ((gameState[12] == activePlayer && gameState[12] == gameState[14] && gameState[14] == gameState[15]) || (gameState[1] == activePlayer && gameState[1] == gameState[5] && gameState[5] == gameState[9]))){ return 13}
        else if (gameState[14] == 0 && ((gameState[12] == activePlayer && gameState[12] == gameState[13] && gameState[13] == gameState[15]) || (gameState[2] == activePlayer && gameState[2] == gameState[6] && gameState[6] == gameState[10]))){ return 14}
        else if (gameState[15] == 0 && ((gameState[12] == activePlayer && gameState[12] == gameState[13] && gameState[13] == gameState[14]) || (gameState[3] == activePlayer && gameState[3] == gameState[7] && gameState[7] == gameState[11]) || (gameState[0] == activePlayer && gameState[0] == gameState[5] && gameState[5] == gameState[10]))){ return 15}
        
        // case 2: if there is a chance to block
        else if (gameState[0] == 0 && ((gameState[1] == passivePlayer && gameState[1] == gameState[2] && gameState[2] == gameState[3]) || (gameState[4] == passivePlayer && gameState[4] == gameState[8] && gameState[8] == gameState[12]) || (gameState[5] == passivePlayer && gameState[5] == gameState[10] && gameState[10] == gameState[15]))){ return 0}
        else if (gameState[1] == 0 && ((gameState[0] == passivePlayer && gameState[0] == gameState[2] && gameState[2] == gameState[3]) || (gameState[5] == passivePlayer && gameState[5] == gameState[9] && gameState[9] == gameState[13]))){ return 1}
        else if (gameState[2] == 0 && ((gameState[0] == passivePlayer && gameState[0] == gameState[1] && gameState[1] == gameState[3]) || (gameState[6] == passivePlayer && gameState[6] == gameState[10] && gameState[10] == gameState[14]))){ return 2}
        else if (gameState[3] == 0 && ((gameState[0] == passivePlayer && gameState[0] == gameState[1] && gameState[1] == gameState[2]) || (gameState[7] == passivePlayer && gameState[7] == gameState[11] && gameState[11] == gameState[15]) || (gameState[6] == passivePlayer && gameState[6] == gameState[9] && gameState[9] == gameState[12]))){ return 3}
            
        else if (gameState[4] == 0 && ((gameState[5] == passivePlayer && gameState[5] == gameState[6] && gameState[6] == gameState[7]) || (gameState[0] == passivePlayer && gameState[0] == gameState[8] && gameState[8] == gameState[12]))){ return 4}
        else if (gameState[5] == 0 && ((gameState[4] == passivePlayer && gameState[4] == gameState[6] && gameState[6] == gameState[7]) || (gameState[1] == passivePlayer && gameState[1] == gameState[9] && gameState[9] == gameState[13]) || (gameState[0] == passivePlayer && gameState[0] == gameState[10] && gameState[10] == gameState[15]))){ return 5}
        else if (gameState[6] == 0 && ((gameState[4] == passivePlayer && gameState[4] == gameState[5] && gameState[5] == gameState[7]) || (gameState[2] == passivePlayer && gameState[2] == gameState[10] && gameState[10] == gameState[14]) || (gameState[3] == passivePlayer && gameState[3] == gameState[9] && gameState[9] == gameState[12]))){ return 6}
        else if (gameState[7] == 0 && ((gameState[4] == passivePlayer && gameState[4] == gameState[5] && gameState[5] == gameState[6]) || (gameState[3] == passivePlayer && gameState[3] == gameState[11] && gameState[11] == gameState[15]))){ return 7}
            
        else if (gameState[8] == 0 && ((gameState[9] == passivePlayer && gameState[9] == gameState[10] && gameState[10] == gameState[11]) || (gameState[0] == passivePlayer && gameState[0] == gameState[4] && gameState[4] == gameState[12]))){ return 8}
        else if (gameState[9] == 0 && ((gameState[8] == passivePlayer && gameState[8] == gameState[10] && gameState[10] == gameState[11]) || (gameState[1] == passivePlayer && gameState[1] == gameState[5] && gameState[5] == gameState[13]) || (gameState[3] == passivePlayer && gameState[3] == gameState[6] && gameState[6] == gameState[12]))){ return 9}
        else if (gameState[10] == 0 && ((gameState[8] == passivePlayer && gameState[8] == gameState[9] && gameState[9] == gameState[11]) || (gameState[2] == passivePlayer && gameState[2] == gameState[6] && gameState[6] == gameState[14]) || (gameState[0] == passivePlayer && gameState[0] == gameState[5] && gameState[5] == gameState[15]))){ return 10}
        else if (gameState[11] == 0 && ((gameState[8] == passivePlayer && gameState[8] == gameState[9] && gameState[9] == gameState[10]) || (gameState[3] == passivePlayer && gameState[3] == gameState[7] && gameState[7] == gameState[15]))){ return 11}
            
        else if (gameState[12] == 0 && ((gameState[13] == passivePlayer && gameState[13] == gameState[14] && gameState[14] == gameState[15]) || (gameState[0] == passivePlayer && gameState[0] == gameState[4] && gameState[4] == gameState[8]) || (gameState[3] == passivePlayer && gameState[3] == gameState[6] && gameState[6] == gameState[9]))){ return 12}
        else if (gameState[13] == 0 && ((gameState[12] == passivePlayer && gameState[12] == gameState[14] && gameState[14] == gameState[15]) || (gameState[1] == passivePlayer && gameState[1] == gameState[5] && gameState[5] == gameState[9]))){ return 13}
        else if (gameState[14] == 0 && ((gameState[12] == passivePlayer && gameState[12] == gameState[13] && gameState[13] == gameState[15]) || (gameState[2] == passivePlayer && gameState[2] == gameState[6] && gameState[6] == gameState[10]))){ return 14}
        else if (gameState[15] == 0 && ((gameState[12] == passivePlayer && gameState[12] == gameState[13] && gameState[13] == gameState[14]) || (gameState[3] == passivePlayer && gameState[3] == gameState[7] && gameState[7] == gameState[11]) || (gameState[0] == passivePlayer && gameState[0] == gameState[5] && gameState[5] == gameState[10]))){ return 15}

        return -1
    }
    
    func aiHardMove() -> Int{
        // attack pre-planning
        if (gameState[0] == 0 && ((gameState[1] == 0 && gameState[2] == activePlayer && gameState[2] == gameState[3]) || (gameState[2] == 0 && gameState[1] == activePlayer && gameState[2] == gameState[3]) ||
            (gameState[3] == 0 && gameState[1] == activePlayer && gameState[1] == gameState[2]) || (gameState[4] == 0 && gameState[8] == activePlayer && gameState[8] == gameState[12]) || (gameState[8] == 0 && gameState[4] == activePlayer && gameState[4] == gameState[12]) || (gameState[12] == 0 && gameState[4] == activePlayer && gameState[4] == gameState[8]) || (gameState[5] == 0 && gameState[10] == activePlayer && gameState[10] == gameState[15]) || (gameState[10] == 0 && gameState[5] == activePlayer && gameState[5] == gameState[15]) || (gameState[15] == 0 && gameState[5] == activePlayer && gameState[5] == gameState[10]))){return 0}
        else if (gameState[1] == 0 && ((gameState[0] == 0 && gameState[2] == activePlayer && gameState[2] == gameState[3]) || (gameState[2] == 0 && gameState[0] == activePlayer && gameState[0] == gameState[3]) || (gameState[3] == 0 && gameState[0] == activePlayer && gameState[0] == gameState[2]) || (gameState[5] == 0 && gameState[9] == activePlayer && gameState[9] == gameState[13]) || (gameState[9] == 0 && gameState[5] == activePlayer && gameState[5] == gameState[13]) || (gameState[13] == 0 && gameState[5] == activePlayer && gameState[5] == gameState[9]))){return 1}
        else if (gameState[2] == 0 && ((gameState[0] == 0 && gameState[1] == activePlayer && gameState[1] == gameState[3]) || (gameState[1] == 0 && gameState[0] == activePlayer && gameState[0] == gameState[3]) ||
            (gameState[3] == 0 && gameState[0] == activePlayer && gameState[0] == gameState[1]) || (gameState[6] == 0 && gameState[10] == activePlayer && gameState[10] == gameState[14]) || (gameState[10] == 0 && gameState[6] == activePlayer && gameState[6] == gameState[14]) && (gameState[14] == 0 && gameState[6] == activePlayer && gameState[6] == gameState[10]))){return 2}
        else if (gameState[3] == 0 && ((gameState[0] == 0 && gameState[1] == activePlayer && gameState[1] == gameState[2]) || (gameState[1] == 0 && gameState[0] == activePlayer && gameState[0] == gameState[2]) || (gameState[2] == 0 && gameState[0] == activePlayer && gameState[0] == gameState[1]) || (gameState[7] == 0 && gameState[11] == activePlayer && gameState[11] == gameState[15]) || (gameState[11] == 0 && gameState[7] == activePlayer && gameState[7] == gameState[15]) || (gameState[15] == 0 && gameState[7] == activePlayer && gameState[7] == gameState[11]) || (gameState[6] == 0 && gameState[9] == activePlayer && gameState[9] == gameState[12]) || (gameState[9] == 0 && gameState[6] == activePlayer && gameState[6] == gameState[12]) || (gameState[12] == 0 && gameState[6] == activePlayer && gameState[6] == gameState[9]))){return 3}
            
        else if (gameState[4] == 0 && ((gameState[5] == 0 && gameState[6] == activePlayer && gameState[6] == gameState[7]) || (gameState[6] == 0 && gameState[5] == activePlayer && gameState[5] == gameState[7]) || (gameState[7] == 0 && gameState[5] == activePlayer && gameState[5] == gameState[6]) || (gameState[0] == 0 && gameState[8] == activePlayer && gameState[8] == gameState[12]) || (gameState[8] == 0 && gameState[0] == activePlayer && gameState[0] == gameState[12]) || (gameState[12] == 0 && gameState[0] == activePlayer && gameState[0] == gameState[8]))){return 4}
        else if (gameState[5] == 0 && ((gameState[4] == 0 && gameState[6] == activePlayer && gameState[6] == gameState[7]) || (gameState[6] == 0 && gameState[4] == activePlayer && gameState[4] == gameState[7]) || (gameState[7] == 0 && gameState[4] == activePlayer && gameState[4] == gameState[6]) || (gameState[1] == 0 && gameState[9] == activePlayer && gameState[9] == gameState[13]) || (gameState[9] == 0 && gameState[1] == activePlayer && gameState[1] == gameState[13]) || (gameState[13] == 0 && gameState[1] == activePlayer && gameState[1] == gameState[9]) || (gameState[0] == 0 && gameState[10] == activePlayer && gameState[10] == gameState[15]) || (gameState[10] == 0 && gameState[0] == activePlayer && gameState[0] == gameState[15]) || (gameState[15] == 0 && gameState[0] == activePlayer && gameState[0] == gameState[10]))){return 5}
        else if (gameState[6] == 0 && ((gameState[4] == 0 && gameState[5] == activePlayer && gameState[5] == gameState[7]) || (gameState[5] == 0 && gameState[4] == activePlayer && gameState[4] == gameState[7]) || (gameState[7] == 0 && gameState[4] == activePlayer && gameState[4] == gameState[5]) || (gameState[2] == 0 && gameState[10] == activePlayer && gameState[10] == gameState[14]) || (gameState[10] == 0 && gameState[2] == activePlayer && gameState[2] == gameState[14]) || (gameState[14] == 0 && gameState[2] == activePlayer && gameState[2] == gameState[10]) || (gameState[3] == 0 && gameState[9] == activePlayer && gameState[9] == gameState[12]) || (gameState[9] == 0 && gameState[3] == activePlayer && gameState[3] == gameState[12]) || (gameState[12] == 0 && gameState[3] == activePlayer && gameState[3] == gameState[12]))){return 6}
        else if (gameState[7] == 0 && ((gameState[4] == 0 && gameState[5] == activePlayer && gameState[5] == gameState[6]) || (gameState[5] == 0 && gameState[4] == activePlayer && gameState[4] == gameState[6]) || (gameState[6] == 0 && gameState[4] == activePlayer && gameState[4] == gameState[5]) || (gameState[3] == 0 && gameState[11] == activePlayer && gameState[11] == gameState[15]) || (gameState[11] == 0 && gameState[3] == activePlayer && gameState[3] == gameState[15]) || (gameState[15] == 0 && gameState[3] == activePlayer && gameState[3] == gameState[11]))){return 7}
            
        else if (gameState[8] == 0 && ((gameState[9] == 0 && gameState[10] == activePlayer && gameState[10] == gameState[11]) || (gameState[10] == 0 && gameState[9] == activePlayer && gameState[9] == gameState[11]) || (gameState[11] == 0 && gameState[9] == activePlayer && gameState[9] == gameState[10]) || (gameState[0] == 0 && gameState[4] == activePlayer && gameState[4] == gameState[12]) || (gameState[4] == 0 && gameState[0] == activePlayer && gameState[0] == gameState[12]) || (gameState[12] == 0 && gameState[0] == activePlayer && gameState[0] == gameState[4]))){return 8}
        else if (gameState[9] == 0 && ((gameState[8] == 0 && gameState[10] == activePlayer && gameState[10] == gameState[11]) || (gameState[10] == 0 && gameState[8] == activePlayer && gameState[8] == gameState[11]) || (gameState[11] == 0 && gameState[8] == activePlayer && gameState[8] == gameState[10]) || (gameState[1] == 0 && gameState[5] == activePlayer && gameState[5] == gameState[13]) || (gameState[5] == 0 && gameState[1] == activePlayer && gameState[1] == gameState[13]) || (gameState[13] == 0 && gameState[1] == activePlayer && gameState[1] == gameState[5]) || (gameState[3] == 0 && gameState[6] == activePlayer && gameState[6] == gameState[12]) || (gameState[6] == 0 && gameState[3] == activePlayer && gameState[3] == gameState[12]) || (gameState[12] == 0 && gameState[3] == activePlayer && gameState[3] == gameState[6]))){return 9}
        else if (gameState[10] == 0 && ((gameState[8] == 0 && gameState[9] == activePlayer && gameState[9] == gameState[11]) || (gameState[9] == 0 && gameState[8] == activePlayer && gameState[8] == gameState[11]) || (gameState[11] == 0 && gameState[8] == activePlayer && gameState[8] == gameState[9]) || (gameState[2] == 0 && gameState[6] == activePlayer && gameState[6] == gameState[14]) || (gameState[6] == 0 && gameState[2] == activePlayer && gameState[2] == gameState[14]) || (gameState[14] == 0 && gameState[2] == activePlayer && gameState[2] == gameState[6]) || (gameState[0] == 0 && gameState[5] == activePlayer && gameState[5] == gameState[15]) || (gameState[5] == 0 && gameState[0] == activePlayer && gameState[0] == gameState[15]) || (gameState[15] == 0 && gameState[0] == activePlayer && gameState[0] == gameState[5]))){return 10}
        else if (gameState[11] == 0 && ((gameState[8] == 0 && gameState[9] == activePlayer && gameState[9] == gameState[10]) || (gameState[9] == 0 && gameState[8] == activePlayer && gameState[8] == gameState[10]) || (gameState[10] == 0 && gameState[8] == activePlayer && gameState[8] == gameState[9]) || (gameState[3] == 0 && gameState[7] == activePlayer && gameState[7] == gameState[15]) || (gameState[7] == 0 && gameState[3] == activePlayer && gameState[3] == gameState[15]) || (gameState[15] == 0 && gameState[3] == activePlayer && gameState[3] == gameState[7]))){return 11}
            
        else if (gameState[12] == 0 && ((gameState[13] == 0 && gameState[14] == activePlayer && gameState[14] == gameState[15]) || (gameState[14] == 0 && gameState[13] == activePlayer && gameState[13] == gameState[15]) ||
            (gameState[15] == 0 && gameState[13] == activePlayer && gameState[13] == gameState[14]) || (gameState[0] == 0 && gameState[4] == activePlayer && gameState[4] == gameState[8]) || (gameState[4] == 0 && gameState[0] == activePlayer && gameState[0] == gameState[8]) || (gameState[8] == 0 && gameState[0] == activePlayer && gameState[0] == gameState[4]) || (gameState[3] == 0 && gameState[6] == activePlayer && gameState[6] == gameState[9]) || (gameState[6] == 0 && gameState[3] == activePlayer && gameState[3] == gameState[9]) || (gameState[9] == 0 && gameState[3] == activePlayer && gameState[3] == gameState[6]))){return 12}
        else if (gameState[13] == 0 && ((gameState[12] == 0 && gameState[14] == activePlayer && gameState[14] == gameState[15]) || (gameState[14] == 0 && gameState[12] == activePlayer && gameState[12] == gameState[15]) || (gameState[15] == 0 && gameState[12] == activePlayer && gameState[12] == gameState[14]) || (gameState[1] == 0 && gameState[5] == activePlayer && gameState[5] == gameState[9]) || (gameState[5] == 0 && gameState[1] == activePlayer && gameState[1] == gameState[9]) || (gameState[9] == 0 && gameState[1] == activePlayer && gameState[1] == gameState[5]))){return 13}
        else if (gameState[14] == 0 && ((gameState[12] == 0 && gameState[13] == activePlayer && gameState[13] == gameState[15]) || (gameState[13] == 0 && gameState[12] == activePlayer && gameState[12] == gameState[15]) || (gameState[15] == 0 && gameState[12] == activePlayer && gameState[12] == gameState[13]) || (gameState[2] == 0 && gameState[6] == activePlayer && gameState[6] == gameState[10]) || (gameState[6] == 0 && gameState[2] == activePlayer && gameState[2] == gameState[10]) || (gameState[10] == 0 && gameState[2] == activePlayer && gameState[2] == gameState[6]))){return 14}
        else if (gameState[15] == 0 && ((gameState[12] == 0 && gameState[13] == activePlayer && gameState[13] == gameState[14]) || (gameState[13] == 0 && gameState[12] == activePlayer && gameState[12] == gameState[14]) ||
            (gameState[14] == 0 && gameState[12] == activePlayer && gameState[12] == gameState[13]) || (gameState[3] == 0 && gameState[7] == activePlayer && gameState[7] == gameState[11]) || (gameState[7] == 0 && gameState[3] == activePlayer && gameState[3] == gameState[11]) || (gameState[11] == 0 && gameState[3] == activePlayer && gameState[3] == gameState[7]) || (gameState[0] == 0 && gameState[5] == activePlayer && gameState[5] == gameState[10]) || (gameState[5] == 0 && gameState[0] == activePlayer && gameState[0] == gameState[10]) || (gameState[10] == 0 && gameState[0] == activePlayer && gameState[0] == gameState[5]))){return 15}
        // defence pre-planning
        else if (gameState[0] == 0 && ((gameState[1] == 0 && gameState[2] == passivePlayer && gameState[2] == gameState[3]) || (gameState[2] == 0 && gameState[1] == passivePlayer && gameState[2] == gameState[3]) ||
            (gameState[3] == 0 && gameState[1] == passivePlayer && gameState[1] == gameState[2]) || (gameState[4] == 0 && gameState[8] == passivePlayer && gameState[8] == gameState[12]) || (gameState[8] == 0 && gameState[4] == passivePlayer && gameState[4] == gameState[12]) || (gameState[12] == 0 && gameState[4] == passivePlayer && gameState[4] == gameState[8]) || (gameState[5] == 0 && gameState[10] == passivePlayer && gameState[10] == gameState[15]) || (gameState[10] == 0 && gameState[5] == passivePlayer && gameState[5] == gameState[15]) || (gameState[15] == 0 && gameState[5] == passivePlayer && gameState[5] == gameState[10]))){return 0}
        else if (gameState[1] == 0 && ((gameState[0] == 0 && gameState[2] == passivePlayer && gameState[2] == gameState[3]) || (gameState[2] == 0 && gameState[0] == passivePlayer && gameState[0] == gameState[3]) || (gameState[3] == 0 && gameState[0] == passivePlayer && gameState[0] == gameState[2]) || (gameState[5] == 0 && gameState[9] == passivePlayer && gameState[9] == gameState[13]) || (gameState[9] == 0 && gameState[5] == passivePlayer && gameState[5] == gameState[13]) || (gameState[13] == 0 && gameState[5] == passivePlayer && gameState[5] == gameState[9]))){return 1}
        else if (gameState[2] == 0 && ((gameState[0] == 0 && gameState[1] == passivePlayer && gameState[1] == gameState[3]) || (gameState[1] == 0 && gameState[0] == passivePlayer && gameState[0] == gameState[3]) ||
            (gameState[3] == 0 && gameState[0] == passivePlayer && gameState[0] == gameState[1]) || (gameState[6] == 0 && gameState[10] == passivePlayer && gameState[10] == gameState[14]) || (gameState[10] == 0 && gameState[6] == passivePlayer && gameState[6] == gameState[14]) && (gameState[14] == 0 && gameState[6] == passivePlayer && gameState[6] == gameState[10]))){return 2}
        else if (gameState[3] == 0 && ((gameState[0] == 0 && gameState[1] == passivePlayer && gameState[1] == gameState[2]) || (gameState[1] == 0 && gameState[0] == passivePlayer && gameState[0] == gameState[2]) || (gameState[2] == 0 && gameState[0] == passivePlayer && gameState[0] == gameState[1]) || (gameState[7] == 0 && gameState[11] == passivePlayer && gameState[11] == gameState[15]) || (gameState[11] == 0 && gameState[7] == passivePlayer && gameState[7] == gameState[15]) || (gameState[15] == 0 && gameState[7] == passivePlayer && gameState[7] == gameState[11]) || (gameState[6] == 0 && gameState[9] == passivePlayer && gameState[9] == gameState[12]) || (gameState[9] == 0 && gameState[6] == passivePlayer && gameState[6] == gameState[12]) || (gameState[12] == 0 && gameState[6] == passivePlayer && gameState[6] == gameState[9]))){return 3}
            
        else if (gameState[4] == 0 && ((gameState[5] == 0 && gameState[6] == passivePlayer && gameState[6] == gameState[7]) || (gameState[6] == 0 && gameState[5] == passivePlayer && gameState[5] == gameState[7]) || (gameState[7] == 0 && gameState[5] == passivePlayer && gameState[5] == gameState[6]) || (gameState[0] == 0 && gameState[8] == passivePlayer && gameState[8] == gameState[12]) || (gameState[8] == 0 && gameState[0] == passivePlayer && gameState[0] == gameState[12]) || (gameState[12] == 0 && gameState[0] == passivePlayer && gameState[0] == gameState[8]))){return 4}
        else if (gameState[5] == 0 && ((gameState[4] == 0 && gameState[6] == passivePlayer && gameState[6] == gameState[7]) || (gameState[6] == 0 && gameState[4] == passivePlayer && gameState[4] == gameState[7]) || (gameState[7] == 0 && gameState[4] == passivePlayer && gameState[4] == gameState[6]) || (gameState[1] == 0 && gameState[9] == passivePlayer && gameState[9] == gameState[13]) || (gameState[9] == 0 && gameState[1] == passivePlayer && gameState[1] == gameState[13]) || (gameState[13] == 0 && gameState[1] == passivePlayer && gameState[1] == gameState[9]) || (gameState[0] == 0 && gameState[10] == passivePlayer && gameState[10] == gameState[15]) || (gameState[10] == 0 && gameState[0] == passivePlayer && gameState[0] == gameState[15]) || (gameState[15] == 0 && gameState[0] == passivePlayer && gameState[0] == gameState[10]))){return 5}
        else if (gameState[6] == 0 && ((gameState[4] == 0 && gameState[5] == passivePlayer && gameState[5] == gameState[7]) || (gameState[5] == 0 && gameState[4] == passivePlayer && gameState[4] == gameState[7]) || (gameState[7] == 0 && gameState[4] == passivePlayer && gameState[4] == gameState[5]) || (gameState[2] == 0 && gameState[10] == passivePlayer && gameState[10] == gameState[14]) || (gameState[10] == 0 && gameState[2] == passivePlayer && gameState[2] == gameState[14]) || (gameState[14] == 0 && gameState[2] == passivePlayer && gameState[2] == gameState[10]) || (gameState[3] == 0 && gameState[9] == passivePlayer && gameState[9] == gameState[12]) || (gameState[9] == 0 && gameState[3] == passivePlayer && gameState[3] == gameState[12]) || (gameState[12] == 0 && gameState[3] == passivePlayer && gameState[3] == gameState[12]))){return 6}
        else if (gameState[7] == 0 && ((gameState[4] == 0 && gameState[5] == passivePlayer && gameState[5] == gameState[6]) || (gameState[5] == 0 && gameState[4] == passivePlayer && gameState[4] == gameState[6]) || (gameState[6] == 0 && gameState[4] == passivePlayer && gameState[4] == gameState[5]) || (gameState[3] == 0 && gameState[11] == passivePlayer && gameState[11] == gameState[15]) || (gameState[11] == 0 && gameState[3] == passivePlayer && gameState[3] == gameState[15]) || (gameState[15] == 0 && gameState[3] == passivePlayer && gameState[3] == gameState[11]))){return 7}
            
        else if (gameState[8] == 0 && ((gameState[9] == 0 && gameState[10] == passivePlayer && gameState[10] == gameState[11]) || (gameState[10] == 0 && gameState[9] == passivePlayer && gameState[9] == gameState[11]) || (gameState[11] == 0 && gameState[9] == passivePlayer && gameState[9] == gameState[10]) || (gameState[0] == 0 && gameState[4] == passivePlayer && gameState[4] == gameState[12]) || (gameState[4] == 0 && gameState[0] == passivePlayer && gameState[0] == gameState[12]) || (gameState[12] == 0 && gameState[0] == passivePlayer && gameState[0] == gameState[4]))){return 8}
        else if (gameState[9] == 0 && ((gameState[8] == 0 && gameState[10] == passivePlayer && gameState[10] == gameState[11]) || (gameState[10] == 0 && gameState[8] == passivePlayer && gameState[8] == gameState[11]) || (gameState[11] == 0 && gameState[8] == passivePlayer && gameState[8] == gameState[10]) || (gameState[1] == 0 && gameState[5] == passivePlayer && gameState[5] == gameState[13]) || (gameState[5] == 0 && gameState[1] == passivePlayer && gameState[1] == gameState[13]) || (gameState[13] == 0 && gameState[1] == passivePlayer && gameState[1] == gameState[5]) || (gameState[3] == 0 && gameState[6] == passivePlayer && gameState[6] == gameState[12]) || (gameState[6] == 0 && gameState[3] == passivePlayer && gameState[3] == gameState[12]) || (gameState[12] == 0 && gameState[3] == passivePlayer && gameState[3] == gameState[6]))){return 9}
        else if (gameState[10] == 0 && ((gameState[8] == 0 && gameState[9] == passivePlayer && gameState[9] == gameState[11]) || (gameState[9] == 0 && gameState[8] == passivePlayer && gameState[8] == gameState[11]) || (gameState[11] == 0 && gameState[8] == passivePlayer && gameState[8] == gameState[9]) || (gameState[2] == 0 && gameState[6] == passivePlayer && gameState[6] == gameState[14]) || (gameState[6] == 0 && gameState[2] == passivePlayer && gameState[2] == gameState[14]) || (gameState[14] == 0 && gameState[2] == passivePlayer && gameState[2] == gameState[6]) || (gameState[0] == 0 && gameState[5] == passivePlayer && gameState[5] == gameState[15]) || (gameState[5] == 0 && gameState[0] == passivePlayer && gameState[0] == gameState[15]) || (gameState[15] == 0 && gameState[0] == passivePlayer && gameState[0] == gameState[5]))){return 10}
        else if (gameState[11] == 0 && ((gameState[8] == 0 && gameState[9] == passivePlayer && gameState[9] == gameState[10]) || (gameState[9] == 0 && gameState[8] == passivePlayer && gameState[8] == gameState[10]) || (gameState[10] == 0 && gameState[8] == passivePlayer && gameState[8] == gameState[9]) || (gameState[3] == 0 && gameState[7] == passivePlayer && gameState[7] == gameState[15]) || (gameState[7] == 0 && gameState[3] == passivePlayer && gameState[3] == gameState[15]) || (gameState[15] == 0 && gameState[3] == passivePlayer && gameState[3] == gameState[7]))){return 11}
            
        else if (gameState[12] == 0 && ((gameState[13] == 0 && gameState[14] == passivePlayer && gameState[14] == gameState[15]) || (gameState[14] == 0 && gameState[13] == passivePlayer && gameState[13] == gameState[15]) ||
            (gameState[15] == 0 && gameState[13] == passivePlayer && gameState[13] == gameState[14]) || (gameState[0] == 0 && gameState[4] == passivePlayer && gameState[4] == gameState[8]) || (gameState[4] == 0 && gameState[0] == passivePlayer && gameState[0] == gameState[8]) || (gameState[8] == 0 && gameState[0] == passivePlayer && gameState[0] == gameState[4]) || (gameState[3] == 0 && gameState[6] == passivePlayer && gameState[6] == gameState[9]) || (gameState[6] == 0 && gameState[3] == passivePlayer && gameState[3] == gameState[9]) || (gameState[9] == 0 && gameState[3] == passivePlayer && gameState[3] == gameState[6]))){return 12}
        else if (gameState[13] == 0 && ((gameState[12] == 0 && gameState[14] == passivePlayer && gameState[14] == gameState[15]) || (gameState[14] == 0 && gameState[12] == passivePlayer && gameState[12] == gameState[15]) || (gameState[15] == 0 && gameState[12] == passivePlayer && gameState[12] == gameState[14]) || (gameState[1] == 0 && gameState[5] == passivePlayer && gameState[5] == gameState[9]) || (gameState[5] == 0 && gameState[1] == passivePlayer && gameState[1] == gameState[9]) || (gameState[9] == 0 && gameState[1] == passivePlayer && gameState[1] == gameState[5]))){return 13}
        else if (gameState[14] == 0 && ((gameState[12] == 0 && gameState[13] == passivePlayer && gameState[13] == gameState[15]) || (gameState[13] == 0 && gameState[12] == passivePlayer && gameState[12] == gameState[15]) || (gameState[15] == 0 && gameState[12] == passivePlayer && gameState[12] == gameState[13]) || (gameState[2] == 0 && gameState[6] == passivePlayer && gameState[6] == gameState[10]) || (gameState[6] == 0 && gameState[2] == passivePlayer && gameState[2] == gameState[10]) || (gameState[10] == 0 && gameState[2] == passivePlayer && gameState[2] == gameState[6]))){return 14}
        else if (gameState[15] == 0 && ((gameState[12] == 0 && gameState[13] == passivePlayer && gameState[13] == gameState[14]) || (gameState[13] == 0 && gameState[12] == passivePlayer && gameState[12] == gameState[14]) ||
            (gameState[14] == 0 && gameState[12] == passivePlayer && gameState[12] == gameState[13]) || (gameState[3] == 0 && gameState[7] == passivePlayer && gameState[7] == gameState[11]) || (gameState[7] == 0 && gameState[3] == passivePlayer && gameState[3] == gameState[11]) || (gameState[11] == 0 && gameState[3] == passivePlayer && gameState[3] == gameState[7]) || (gameState[0] == 0 && gameState[5] == passivePlayer && gameState[5] == gameState[10]) || (gameState[5] == 0 && gameState[0] == passivePlayer && gameState[0] == gameState[10]) || (gameState[10] == 0 && gameState[0] == passivePlayer && gameState[0] == gameState[5]))){return 15}
        return -1
    }
    
    func updateScore(){
        lblP1Score.text = String(UserDefaults.standard.integer(forKey: "p1Wins"))
        lblP2Score.text = String(UserDefaults.standard.integer(forKey: "p2Wins"))
    }
    
    func makeMove(){
        stopTimer()
        // for testing
        //trivia = true
        if (trivia){
            gameState[tempTag - 1] = activePlayer
            let button = view.viewWithTag(tempTag) as! UIButton
            if (activePlayer == 1) {
                button.setImage(UIImage(named:p1symbol), for: UIControlState())
                //nextPlayerOutlet.text = "0's turn"
                //activePlayer = 2
            } else {
                button.setImage(UIImage(named:p2symbol), for: UIControlState())
                //nextPlayerOutlet.text = "X's turn"
                //activePlayer = 1
            }
            popDrop()
            //Decrease the number of moves remaining by one each time a user makes a move
            remainingMoves -= 1
            checkForWinner()
            checkForDraw()
            if (gameMode == 3){
                setGameMove(position: tempTag - 1)
                onlineTurn = true
            }
        } else {
            if (gameMode == 3){
                skippedTurnsOnline -= 1
                setGameMove(position: skippedTurnsOnline)
                onlineTurn = true
                
            }
        }
        
        if (gameActive){
            switchTurn()
        }
    }
    
   
    func tieBreakWinnerCheck(){
        isADraw = false
        if tieBreakWinner == 1 {
            messageBoard.text = p1Name + " won!";
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "p1Wins") + 1, forKey: "p1Wins")
        }
        else {
            messageBoard.text = p2Name + " won!";
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "p2Wins") + 1, forKey: "p2Wins")
            
        }
        updateScore()
        someOneWon()
        DispatchQueue.main.async() {
            [unowned self] in
            self.performSegue(withIdentifier: "winnerSegue", sender: self)
        }
        
    }
    
    func enemySurrender(){
        gameActive = false

        someOneWon()
        DispatchQueue.main.async() {
            [unowned self] in
            self.performSegue(withIdentifier: "winnerSegue", sender: self)
        }
        
    }
    
    func checkForWinner(){
        for combination in winningCombinations
        {
            if gameState[combination[0]] != 0 && gameState[combination[0]] == gameState[combination[1]] && gameState[combination[1]] == gameState[combination[2]] && gameState[combination[2]] == gameState[combination[3]] {
                gameActive = false
                if gameState[combination[0]] == 1 {
                    //Cross has won
                    messageBoard.text = p1Name + " won!"
                    UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "p1Wins") + 1, forKey: "p1Wins")
                } else {
                    //Nought has won
                    messageBoard.text = p2Name + " won!"
                    UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "p2Wins") + 1, forKey: "p2Wins")
                    
                }
                updateScore()
                someOneWon()
                DispatchQueue.main.async() {
                    [unowned self] in
                    self.performSegue(withIdentifier: "winnerSegue", sender: self)
                }
            }
        }
    
    }
    
    func checkForDraw(){
        if(remainingMoves == 0 && gameActive) {
            //set the gameActivity to false - cannot make a move
            gameActive = false
            stopTimer()
            if (gameMode == 2){
                parseTieBreak()
                isADraw = true
            }
            messageBoard.text = "It's a draw!"
            noOneWon()
            DispatchQueue.main.async() {
                [unowned self] in
                self.performSegue(withIdentifier: "winnerSegue", sender: self)
            }

        }
        
    }
    
    
    func triviaResult() {
        selectQuestion()
        DispatchQueue.main.async() {
            [unowned self] in
            self.performSegue(withIdentifier: "tempTriviaSegue", sender: self)
        }

    }
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
    
    func prepareGame(){
        getGameParameters()
        getTheme()
        p1Label.text = p1Name
        p2Label.text = p2Name
        messageBoard.text = p1Name + "'s turn to play!"
        
        // --- *** --- \\
        
        if (UserDefaults.standard.integer(forKey: "bgMusic") == 1){
            soundOffBtn.isHidden = true
            soundBtn.isHidden = false
            playSound()
        } else {
            soundBtn.isHidden = true
            soundOffBtn.isHidden = false
        }
        soundOffBtn.adjustsImageWhenHighlighted = false;
        soundBtn.adjustsImageWhenHighlighted = false;
        pauseBtn.adjustsImageWhenHighlighted = false;
        homeBtn.adjustsImageWhenHighlighted = false;
        homeBtn.isHidden = true
        vsImage.isHidden = true
        progressBar.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 3);
        
        // --- *** --- \\

        resetGrid();
        let rounds = UserDefaults.standard.integer(forKey: "roundsPlayed") + 1
        UserDefaults.standard.set(rounds, forKey: "roundsPlayed")


        assignSymbols();
        if (sBackground){
            playSound();
        }
        updateScore()
        startTimer();
     
        if (gameMode == 3){
            pauseBtn.isHidden = true
            helpBtn.isHidden = true
            homeBtn.isHidden = false
            lblP1Score.isHidden = true
            lblP2Score.isHidden = true
            lblScoreDiv.isHidden = true
            vsImage.isHidden = false
            if localPlayer == 2{
                if rounds % 2 != 0 || rounds == 1 {
                    stopTimer()
                    onlineTurn = true
                    self.view?.isUserInteractionEnabled = false
                    startOnlineTimer()
                }
            } else {
                if rounds % 2 == 0 {
                    stopTimer()
                    onlineTurn = true
                    self.view?.isUserInteractionEnabled = false
                    switchTurn()
                }
            }
        }
        if rounds % 2 == 0 {
            if (gameMode == 1){
                aiTurn = true
            }
            switchTurn()
        }

    }
    
    
    func resetGrid(){
        for i in 1...16 {
            let button = view.viewWithTag(i) as! UIButton
            button.setImage(nil, for: UIControlState());
            button.adjustsImageWhenHighlighted = false;
        }
        //reset the gameActivity to true - enabling user to play again
        gameActive = true
        //reset the gameState to the beginning state
        gameState = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        //reset the player to player 1
        activePlayer = 1
        p1Label.textColor = UIColor.white
        p1Label.backgroundColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0)
        //reset the remaining moves
        remainingMoves = 16
        
    }
    
    @IBAction func pauseButtonClicked(_ sender: Any) {
        timer.invalidate()
        DispatchQueue.main.async() {
            [unowned self] in
            self.performSegue(withIdentifier: "gameMenuSegue", sender: self)
        }
  
    }
    
    func switchTurn(){
        if (activePlayer == 1){
            activePlayer = 2
            p1Label.textColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0)
            p1Label.backgroundColor = UIColor.white
            p2Label.textColor = UIColor.white
            p2Label.backgroundColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0)
            messageBoard.text = p2Name + "'s turn to play!"
            
        } else {
            activePlayer = 1
            p1Label.textColor = UIColor.white
            p1Label.backgroundColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0)
            p2Label.textColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0)
            p2Label.backgroundColor = UIColor.white
            messageBoard.text = p1Name + "'s turn to play!"
        }

        startTimer()
        if (gameMode == 1 && aiTurn == true){
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                self.trivia = true
                self.makeMoveAI()
                
            })
        }
        if (gameMode == 3){
           
            if onlineTurn == true
            {
                // for testing
                //trivia = true
                stopTimer()
                startOnlineTimer()
            }
        }

        //startTimer()
    }
    
    func startTimer(){

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameSessionViewController.go), userInfo: nil, repeats: true);
    }
    
    func stopTimer(){
        timer.invalidate();
        timer = Timer();
        self.progressBar.progress = 0.0;
    }

    @objc func go(){
        progressBar.progress += 0.032; //30 sec
        if (progressBar.progress == 1){
            stopTimer();
            if (gameMode == 1){
                aiTurn = true
                self.view?.isUserInteractionEnabled = false
            } else if (gameMode == 3){
                if activePlayer == localPlayer {
                    skippedTurnsOnline -= 1
                    let alert = UIAlertController(title: "Time's up!?", message: "Since you took too long to make your move, you lost your turn!", preferredStyle: .alert);
                    
                    alert.addAction(UIAlertAction(title: "Nooo!?!", style: .default, handler: { action in self.setGameMove(position: self.skippedTurnsOnline); self.switchTurn();}))
                    alert.view.tintColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0)
                    self.present(alert, animated: true);
                    
                }
            }
            let alert = UIAlertController(title: "Time's up!?", message: "Since you took too long to make your move, you lost your turn!", preferredStyle: .alert);
            
            alert.addAction(UIAlertAction(title: "Nooo!?!", style: .default, handler: { action in self.switchTurn()}))
            alert.view.tintColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0)
            self.present(alert, animated: true);
            
        }
    }
   
    func playSound() {
         player?.setVolume(0.3, fadeDuration: 2)
    }
    
    func selectQuestion()
    {
        let selection = questionCounter;
        var tempQuestion:[String] = []
        var arrayAnswers = questionsArray[selection]["incorrect_answers"] as! Array<String>
        let rightAnswer = questionsArray[selection]["correct_answer"] as! String;
        arrayAnswers.append(rightAnswer)
        var shuffledAnswer = Arrayshuffle(arrayAnswers: arrayAnswers)
        
        tempQuestion.append ((questionsArray[selection]["question"] as! String).decodingHTMLEntities());
        tempQuestion.append(rightAnswer)
        tempQuestion.append(shuffledAnswer[0].decodingHTMLEntities());
        tempQuestion.append(shuffledAnswer[1].decodingHTMLEntities());
        tempQuestion.append(shuffledAnswer[2].decodingHTMLEntities());
        tempQuestion.append(shuffledAnswer[3].decodingHTMLEntities());
        if questionCounter < 49 {
            questionCounter += 1
        } else {
            questionCounter = 0
        }
        singleQuestion = tempQuestion
 
    }
    
    func Arrayshuffle(arrayAnswers: [String]) -> [String]{
        var items = arrayAnswers
        var shuffled = [String]();
        
        for _ in 0..<items.count
        {
            let rand = Int(arc4random_uniform(UInt32(items.count)))
            
            shuffled.append(items[rand])
            
            items.remove(at: rand)
        }
        return shuffled
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "tempTriviaSegue"{
            let controller = segue.destination as! QuizViewController
            controller.questionArray = singleQuestion
        } else if (segue.identifier == "winnerSegue" && isADraw) {
            let controller = segue.destination as! WinnerOutcomeViewController
            controller.imageLabel = "Tie Break"
            controller.outcomeText = "It's a draw!"
            controller.p1Name = p1Name
            controller.p2Name = p2Name
            //controller.imageLoc = "trophy.png"
            controller.tieBreakerQuestions = tieBreakParse
        } else if (segue.identifier == "gameToHelpSegue" ){
            let controller = segue.destination as! HelpMasterTableViewController
            controller.segueFromGame = true
        }
    }
    
    func popDrop() {
        
        if UserDefaults.standard.integer(forKey:"soundEffects") == 1 {
        
            guard let url = Bundle.main.url(forResource: "pop_drip", withExtension: "wav") else {return}

            do{
                audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
                guard let audioPlayer = audioPlayer else {return}
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func someOneWon() {
        
        if UserDefaults.standard.integer(forKey:"soundEffects") == 1 {
            
            guard let url = Bundle.main.url(forResource: "music_marimba_chord", withExtension: "wav") else {return}
            
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
                guard let audioPlayer = audioPlayer else {return}
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
    }
    
    
    func noOneWon() {
        
        if UserDefaults.standard.integer(forKey:"soundEffects") == 1 {
            
            guard let url = Bundle.main.url(forResource: "AndNow", withExtension: "wav") else {return}
            
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
                guard let audioPlayer = audioPlayer else {return}
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
    }
    
    
    func parseTieBreak(){
        for i in 0..<50
        {
            let rightAnswer = tieBreakArray[i]["correct_answer"] as! String;
            tieBreakParse.append ([(tieBreakArray[i]["question"] as! String).decodingHTMLEntities(), rightAnswer]);
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareGame();
        //triviaResult()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
