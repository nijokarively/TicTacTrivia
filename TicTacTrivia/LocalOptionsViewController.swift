//
//  LocalOptionsViewController.swift
//  TicTacTrivia
//
//  Created by nijo on 29/03/2018.
//  Copyright © 2018 Nijo. All rights reserved.
//

import UIKit

class LocalOptionsViewController: UIViewController, UITextFieldDelegate {
    
    var p1SymbolFlag = 0
    
    @IBOutlet var backgroundImage: UIImageView!
    
    @IBOutlet var p1NameText: UITextField!
    @IBOutlet var p2NameText: UITextField!
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            p1SymbolFlag = 0;
        case 1:
            p1SymbolFlag = 1;
        default:
            break;
        }
    }
    @IBAction func startButtonClicked(_ sender: Any) {
        DispatchQueue.main.async() {
            [unowned self] in
            self.performSegue(withIdentifier: "localGridSegue", sender: self)
        }
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "localGridSegue"{
            if p1NameText.text != "" {
                UserDefaults.standard.set(p1NameText.text!, forKey: "p1Name")
            }
            if p2NameText.text != "" {
                UserDefaults.standard.set(p2NameText.text!, forKey: "p2Name")
            }
            UserDefaults.standard.set(p1SymbolFlag, forKey: "userSymbol")
            UserDefaults.standard.set(2, forKey: "gameMode")
        }
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
       
        // Do any additional setup after loading the view.
    }
    
    func prepareView(){
        self.p1NameText.delegate = self
        self.p2NameText.delegate = self
        //p1NameText.text = UserDefaults.standard.string(forKey: "p1Name")
        backgroundImage.layer.borderWidth = 2
        backgroundImage.layer.borderColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0).cgColor
        
        p1NameText.layer.borderWidth = 1
        p1NameText.layer.borderColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0).cgColor
        
        p2NameText.layer.borderWidth = 1
        p2NameText.layer.borderColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0).cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

}
