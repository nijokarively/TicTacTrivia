//
//  GameMenuViewController.swift
//  TicTacTrivia
//
//  Created by nijo on 29/03/2018.
//  Copyright © 2018 Nijo. All rights reserved.
//

import UIKit

class GameMenuViewController: UIViewController {
    
    @IBOutlet weak var btnResume: UIButton!
    @IBOutlet weak var btnMainMenu: UIButton!
    @IBOutlet weak var btnOptions: UIButton!
    @IBOutlet weak var btnRestart: UIButton!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBAction func resumeButtonClicked(_ sender: Any) {
        //unwind segue to be done
        //dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "unwindSegueMenuToGame", sender: self)
    }
    @IBAction func mainMenuButtonClicked(_ sender: Any) {
        DispatchQueue.main.async() {
            [unowned self] in
            self.performSegue(withIdentifier: "backToMainMenuSegue", sender: self)
            
        }
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "unwindSegueMenuToGame"{
            let controller = segue.destination as! GameSessionViewController
            //controller.stopTimer();
            controller.startTimer();
        }
    }
    @IBAction func optionsButtonClicked(_ sender: Any) {
        DispatchQueue.main.async() {
            [unowned self] in
            self.performSegue(withIdentifier: "gameMenuToSettingsSegue", sender: self)
        }
        
    }
    @IBAction func restartButtonClicked(_ sender: Any) {
        DispatchQueue.main.async() {
            [unowned self] in
            self.performSegue(withIdentifier: "restartSegue", sender: self)
        }
    }
    
    func prepareView(){
        backgroundImage.layer.borderWidth = 2
        backgroundImage.layer.borderColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0).cgColor
        btnResume.layer.cornerRadius = 26
        btnResume.clipsToBounds = true
        btnMainMenu.layer.cornerRadius = 26
        btnMainMenu.clipsToBounds = true
        btnOptions.layer.cornerRadius = 26
        btnOptions.clipsToBounds = true
        btnRestart.layer.cornerRadius = 26
        btnRestart.clipsToBounds = true
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
