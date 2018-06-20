//
//  SettingsViewController.swift
//  TicTacTrivia
//
//  Created by nijo on 29/03/2018.
//  Copyright © 2018 Nijo. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var segTriviaDiff: UISegmentedControl!
    @IBOutlet weak var segSEffect: UISegmentedControl!
    @IBOutlet weak var segTheme: UISegmentedControl!
    @IBOutlet var backgroundImage: UIImageView!
    var theme = 0
    var sEffects = 0
    var triviaDiff = 0
    @IBAction func saveButtonClicked(_ sender: Any) {
        saveSettings()
        let alert = UIAlertController(title: "Changes saved!", message: "Any changes will only be applied to the next game session!", preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{action in self.goBack()}))
        alert.view.tintColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0)
        self.present(alert, animated: true);
    }
    
    func goBack(){
 
        dismiss(animated: true, completion: nil)
    }
    
    func saveSettings(){
        triviaDiff = segTriviaDiff.selectedSegmentIndex
        theme = segTheme.selectedSegmentIndex
        sEffects  = segSEffect.selectedSegmentIndex
        UserDefaults.standard.set(triviaDiff, forKey: "triviaLevel")
        UserDefaults.standard.set(sEffects, forKey: "soundEffects")
        UserDefaults.standard.set(theme, forKey: "theme")
    }
    
    func prepareView(){
        backgroundImage.layer.borderWidth = 2
        backgroundImage.layer.borderColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0).cgColor
        theme = UserDefaults.standard.integer(forKey: "theme")
        triviaDiff = UserDefaults.standard.integer(forKey: "triviaLevel")
        sEffects = UserDefaults.standard.integer(forKey: "soundEffects")
        segTheme.selectedSegmentIndex = theme
        segTriviaDiff.selectedSegmentIndex = triviaDiff
        segSEffect.selectedSegmentIndex = sEffects
        btnSave.layer.cornerRadius = 26
        btnSave.clipsToBounds = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
