//
//  QuizViewController.swift
//  TicTacTrivia
//
//  Created by nijo on 30/03/2018.
//  Copyright © 2018 Nijo. All rights reserved.
//

import UIKit
import AVFoundation

class QuizViewController: UIViewController {

    @IBOutlet weak var btnAnswer1: UIButton!
    @IBOutlet weak var btnAnswer2: UIButton!
    @IBOutlet weak var btnAnswer3: UIButton!
    @IBOutlet weak var btnAnswer4: UIButton!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var lblMessage: UILabel!
    
    var tempResult = false
    
    var rightAnswer:String = ""
    
    var timer = Timer()
    
    //Array initialisation
    var questionArray : [String] = []
    
    var counter = 1
    
    var p1Score = 0
    
    var p2Score = 0
    
    var audioPlayer:AVAudioPlayer?
    
    
    func prepareLayout(){
        btnAnswer1.layer.borderWidth = 2
        btnAnswer1.layer.borderColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0).cgColor
        btnAnswer1.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        btnAnswer2.layer.borderWidth = 2
        btnAnswer2.layer.borderColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0).cgColor
        btnAnswer2.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        btnAnswer3.layer.borderWidth = 2
        btnAnswer3.layer.borderColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0).cgColor
        btnAnswer3.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        btnAnswer4.layer.borderWidth = 2
        btnAnswer4.layer.borderColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0).cgColor
        btnAnswer4.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        progressBar.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
        progressBar.transform = progressBar.transform.scaledBy(x: 1, y: 3);
        lblMessage.text = ""
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
        progressBar.progress += 0.064; //15 sec
        if (progressBar.progress == 1){
            stopTimer();
            let alert = UIAlertController(title: "Time's up!?", message: "Since you took too long to make your move, you lost your turn!", preferredStyle: .alert);
            
            alert.addAction(UIAlertAction(title: "Oh well..", style: .default, handler: { action in self.goBackToGame()}));
            self.present(alert, animated: true);
        }
    }

    func goBackToGame(){
//        dismiss(animated: true, completion: nil)
         performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
    }
    

    @IBAction func buttonClicked(_ sender: UIButton) {
        stopTimer()
        disableButtons()   
        if (sender.titleLabel!.text == rightAnswer){
            correctSound()
            tempResult = true
            lblMessage.text = "Correct!"
        } else {
            wrongSound()
            tempResult = false
            lblMessage.text = "Wrong!"
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.goBackToGame()
        })
        
    }
    
    func correctSound() {
        
        if UserDefaults.standard.integer(forKey:"soundEffects") == 1 {
            
            guard let url = Bundle.main.url(forResource: "right", withExtension: "mp3") else {return}
            
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                guard let audioPlayer = audioPlayer else {return}
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func wrongSound() {
        
        if UserDefaults.standard.integer(forKey:"soundEffects") == 1 {
            
            guard let url = Bundle.main.url(forResource: "wrong", withExtension: "mp3") else {return}
            
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                guard let audioPlayer = audioPlayer else {return}
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
    }
    
    
    func disableButtons(){
        btnAnswer1.isUserInteractionEnabled = false
        btnAnswer2.isUserInteractionEnabled = false
        btnAnswer3.isUserInteractionEnabled = false
        btnAnswer4.isUserInteractionEnabled = false
    }
    
    func selectQuestion()
    {
        lblQuestion.text = questionArray[0];
        rightAnswer = questionArray[1].decodingHTMLEntities()
        
        btnAnswer1.setTitle(questionArray[2].decodingHTMLEntities(), for: .normal);
        btnAnswer2.setTitle(questionArray[3].decodingHTMLEntities(), for: .normal);
        btnAnswer3.setTitle(questionArray[4].decodingHTMLEntities(), for: .normal);
        btnAnswer4.setTitle(questionArray[5].decodingHTMLEntities(), for: .normal);

        startTimer()
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareLayout()
        self.selectQuestion()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "unwindSegueToVC1"{
            let controller = segue.destination as! GameSessionViewController
            controller.trivia = tempResult
            controller.stopTimer();
            controller.makeMove();
        }
    }
}
