//
//  WinnerOutcomeViewController.swift
//  TicTacTrivia
//
//  Created by nijo on 02/04/2018.
//  Copyright © 2018 Nijo. All rights reserved.
//

import UIKit

class WinnerOutcomeViewController: UIViewController {

    var outcomeText = "Game Over!"
    //var imageLoc = "share-alt.png"
    var imageLabel = "Share"
    var p1Name = ""
    var p2Name = ""
    var tieBreakerQuestions: [[String]] = []
    
    @IBOutlet weak var tieBreakButton: UIButton!
    @IBOutlet weak var lblLeft: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var lblOutcome: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBAction func rematchButtonPressed(_ sender: Any) {
        DispatchQueue.main.async() {
            [unowned self] in
            if UserDefaults.standard.integer(forKey: "gameMode") == 3 {
                UserDefaults.standard.set(0, forKey: "roundsPlayed")
                UserDefaults.standard.set(0, forKey: "p2Wins")
                UserDefaults.standard.set(0, forKey: "p2Wins")
                UserDefaults.standard.set(0, forKey: "onlineStatus")
                self.performSegue(withIdentifier: "onlineRematchSegue", sender: self)}
            else {
                self.performSegue(withIdentifier: "winnerGameReloadSegue", sender: self)
                
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        DispatchQueue.main.async() {
            [unowned self] in
            self.performSegue(withIdentifier: "winnerBackToMainSegue", sender: self)
        }
    }
    
    
    @IBAction func shareButtonPressed(_ sender: Any) {
        let shareText:String = "Try the ultimate Tic-Tac-Toe game: T3"
        let activityViewController = UIActivityViewController(
            activityItems: [shareText as NSString],
            applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        present(activityViewController, animated: true, completion: nil)
    }    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.layer.borderWidth = 2
        backgroundImage.layer.borderColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0).cgColor        // Do any additional setup after loading the view.
        lblOutcome.text = outcomeText
        //btnLeft.setImage(UIImage(named:imageLoc), for: UIControlState())
        lblLeft.text = imageLabel
        if (tieBreakerQuestions.isEmpty == false){
            btnLeft.isEnabled = false
            btnLeft.isHidden = true
            tieBreakButton.isEnabled = true
            tieBreakButton.isHidden = false
        } else {
            tieBreakButton.isEnabled = false
            tieBreakButton.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tieBreakPressed(_ sender: Any) {
        DispatchQueue.main.async() {
            [unowned self] in
            self.performSegue(withIdentifier: "tieBreakSegue", sender: self)
        }
    }

    override func prepare (for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "tieBreakSegue"{
            let controller = segue.destination as! TieBreakViewController
            controller.tieBreakerQuestions = tieBreakerQuestions
            controller.p1Name = p1Name
            controller.p2Name = p2Name
                   
        }
    }
}
