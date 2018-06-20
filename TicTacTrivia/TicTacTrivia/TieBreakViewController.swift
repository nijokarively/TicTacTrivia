//
//  TieBreakViewController.swift
//  TicTacTrivia
//
//  Created by nijo on 03/04/2018.
//  Copyright © 2018 Nijo. All rights reserved.
//

import UIKit
import AVFoundation

class TieBreakViewController: UIViewController {
   var tieBreakerQuestions: [[String]] = []
    
    @IBOutlet weak var btnAnswer1: UIButton!
    @IBOutlet weak var btnAnswer2: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var p1Label: UILabel!
    @IBOutlet weak var p2Label: UILabel!
    @IBOutlet weak var lblP1Score: UILabel!
    @IBOutlet weak var lblP2Score: UILabel!
    
    var timer = Timer()
    var counter = 0
    var rightAnswer = ""
    var activePlayer = 1
    var p1Score = 0
    var p2Score = 0
    var winner = 0
    var p1Name = ""
    var p2Name = ""
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareLayout()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareLayout(){
        btnAnswer1.layer.borderWidth = 2
        btnAnswer1.layer.borderColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0).cgColor
        
        btnAnswer2.layer.borderWidth = 2
        btnAnswer2.layer.borderColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0).cgColor
        
        progressBar.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 3);
        lblMessage.text = ""
        
        p1Label.textColor = UIColor.white
        p1Label.backgroundColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0)
        p2Label.textColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0)
        p2Label.backgroundColor = UIColor.white
        p1Label.text = p1Name
        p2Label.text = p2Name
        startTimer()
        selectQuestion()
        timerSound()
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
        progressBar.progress += 0.192; //5 sec
        if (progressBar.progress == 1){
            stopTimer();
            let alert = UIAlertController(title: "Time's up!?", message: "Since you took too long to make your move, you lost your turn!", preferredStyle: .alert);
            
            alert.addAction(UIAlertAction(title: "Oh well..", style: .default, handler: { action in self.selectQuestion()}));
            self.present(alert, animated: true);
        }
    }
    
    func someOneWon() {
        
        if UserDefaults.standard.integer(forKey:"soundEffects") == 1 {
            
            guard let url = Bundle.main.url(forResource: "music_marimba_chord", withExtension: "wav") else {return}
            
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
                guard let audioPlayer = audioPlayer else {return}
                audioPlayer.numberOfLoops = 0
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func timerSound() {
        
        if UserDefaults.standard.integer(forKey:"soundEffects") == 1 {
            
            guard let url = Bundle.main.url(forResource: "timer", withExtension: "wav") else {return}
            
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
                guard let audioPlayer = audioPlayer else {return}
                audioPlayer.numberOfLoops = -1
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
    }
    
    
    func goBackToGame(){
        //        dismiss(animated: true, completion: nil)
        disableButtons()
        someOneWon()
        if (p1Score > p2Score){ winner = 1; lblMessage.text = p1Name + " won!";}
        else {winner = 2; lblMessage.text = p2Name + " won!";}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
            self.performSegue(withIdentifier: "tieBreakToGameSegue", sender: self)
        })
        
    }
    
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        stopTimer()
        disableButtons()
        if (sender.titleLabel!.text == rightAnswer){
            lblMessage.text = "Correct!"
            if activePlayer == 1 {
                p1Score += 1
            } else {
                p2Score += 1
            }
        } else {
            lblMessage.text = "Wrong!"
        }
        switchTurn()
        selectQuestion()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
//            self.goBackToGame()
//        })
        
    }
    
    func disableButtons(){
        btnAnswer1.isUserInteractionEnabled = false
        btnAnswer2.isUserInteractionEnabled = false
    }
    
    func enableButtons(){
        btnAnswer1.isUserInteractionEnabled = true
        btnAnswer2.isUserInteractionEnabled = true
    }
    
    
    func selectQuestion()
    {
        enableButtons()
        updateScore()
        lblQuestion.text = tieBreakerQuestions[counter][0];
        rightAnswer = tieBreakerQuestions[counter][1]
        btnAnswer1.setTitle("True", for: .normal);
        btnAnswer2.setTitle("False", for: .normal);
        if (counter >= 10 && counter % 2 == 0 && p1Score != p2Score){
            goBackToGame()
        }
        counter += 1
       // switchTurn()
    }
    
    func updateScore(){
        lblP1Score.text = String(p1Score)
        lblP2Score.text = String(p2Score)
    }
    
    func switchTurn(){
        if (activePlayer == 1){
            activePlayer = 2
            p1Label.textColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0)
            p1Label.backgroundColor = UIColor.white
            p2Label.textColor = UIColor.white
            p2Label.backgroundColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0)
            //messageBoard.text = p2Name + "'s turn to play!"
            
        } else {
            activePlayer = 1
            p1Label.textColor = UIColor.white
            p1Label.backgroundColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0)
            p2Label.textColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0)
            p2Label.backgroundColor = UIColor.white
            //messageBoard.text = p1Name + "'s turn to play!"
        }
        startTimer()
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "tieBreakToGameSegue"{
            let controller = segue.destination as! GameSessionViewController
            controller.tieBreakWinner = winner;
            controller.tieBreakWinnerCheck();
        }
    }
}
