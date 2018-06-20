//
//  SingleOptionsViewController.swift
//  TicTacTrivia
//
//  Created by nijo on 28/03/2018.
//  Copyright © 2018 Nijo. All rights reserved.
//

import UIKit

class SingleOptionsViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var segAiLevel: UISegmentedControl!
    @IBOutlet weak var segSelectSymbol: UISegmentedControl!
    var p1SymbolFlag = 0
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var nameText: UITextField!
    @IBAction func startButtonClicked(_ sender: Any) {
        DispatchQueue.main.async() {
            [unowned self] in
            self.performSegue(withIdentifier: "singleGridSegue", sender: self)
        }
    }
    
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
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "singleGridSegue"{
            UserDefaults.standard.set(1, forKey: "gameMode")
            if nameText.text != "" {
                UserDefaults.standard.set(nameText.text!, forKey: "p1Name")
            }
            UserDefaults.standard.set("AI", forKey: "p2Name")
            UserDefaults.standard.set(segAiLevel.selectedSegmentIndex, forKey: "aiLevel")
            UserDefaults.standard.set(p1SymbolFlag, forKey: "userSymbol")
        }
    }
    
    func prepareView(){
        self.nameText.delegate = self
        backgroundImage.layer.borderWidth = 2
        backgroundImage.layer.borderColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0).cgColor
        
        nameText.layer.borderWidth = 1
        nameText.layer.borderColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0).cgColor
        //nameText.text = UserDefaults.standard.string(forKey: "p1Name")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       prepareView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
