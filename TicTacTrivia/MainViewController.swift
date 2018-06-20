//
//  MainViewController.swift
//  TicTacTrivia
//
//  Created by nijo on 28/03/2018.
//  Copyright © 2018 Nijo. All rights reserved.
//

import UIKit
import AVFoundation

var player: AVAudioPlayer?

class MainViewController: UIViewController {
    
    @IBOutlet weak var btnSingle: UIButton!
    @IBOutlet weak var btnMulti: UIButton!
    @IBOutlet weak var btnHelp: UIButton!
    @IBOutlet var soundBtn: UIButton!
    @IBOutlet var settingsBtn: UIButton!
    @IBOutlet var soundOffBtn: UIButton!
    @IBAction func settingButton(_ sender: UIButton) {
        let btnsendtag: UIButton = sender
        if btnsendtag.tag == 1 {
        DispatchQueue.main.async() {
            [unowned self] in
            self.performSegue(withIdentifier: "settingsSegue", sender: self)
            }
        }
    }
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
    @IBAction func singleModeOptions(_ sender: Any) {
        DispatchQueue.main.async() {
            [unowned self] in
            self.performSegue(withIdentifier: "singleOptionSegue", sender: self)
        }
    }
    
    func soundStop(){
        player?.stop()
    }
    
    @IBAction func multiModeClicked(_ sender: Any) {
        DispatchQueue.main.async() {
            [unowned self] in
            self.performSegue(withIdentifier: "multiModeSegue", sender: self)
        }
    }
    
    @IBAction func unwindToMainVC(segue:UIStoryboardSegue) { }
    

    
    
    @IBAction func helpButtonPressed(_ sender: Any) {
        DispatchQueue.main.async() {
            [unowned self] in
            self.performSegue(withIdentifier: "mainHelpSegue", sender: self)
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "mainTheme", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            player?.numberOfLoops = -1
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            player.setVolume(0.6, fadeDuration: 2)
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        settingsBtn.adjustsImageWhenHighlighted = false;
        prepareButtons()
        prepareUserDefaults()
        
        
        // Do any additional setup after loading the view.
    }
    
    func prepareUserDefaults(){
        UserDefaults.standard.set("Player 2", forKey: "p2Name")
        UserDefaults.standard.set(0, forKey: "p1Wins")
        UserDefaults.standard.set(0, forKey: "p2Wins")
        UserDefaults.standard.set(0, forKey: "roundsPlayed")
    }
    
    func prepareButtons(){
        btnHelp.layer.cornerRadius = 26
        btnHelp.clipsToBounds = true
        btnMulti.layer.cornerRadius = 26
        btnMulti.clipsToBounds = true
        btnSingle.layer.cornerRadius = 26
        btnSingle.clipsToBounds = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
