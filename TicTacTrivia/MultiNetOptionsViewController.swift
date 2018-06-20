//
//  MultiNetOptionsViewController.swift
//  TicTacTrivia
//
//  Created by nijo on 09/04/2018.
//  Copyright © 2018 Nijo. All rights reserved.
//

import UIKit

class MultiNetOptionsViewController: UIViewController {
    @IBOutlet weak var symbolSeg: UISegmentedControl!
    
    @IBOutlet weak var txtP1Name: UITextField!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    var pName = "Anon"
    
    @IBAction func startButtonPressed(_ sender: Any) {
        if txtP1Name.text != ""
        {
            pName = txtP1Name.text!
        } else {
            pName += (UIDevice.current.identifierForVendor!.uuidString.prefix(4))
        }
        UserDefaults.standard.set(pName, forKey: "onlineName")
        DispatchQueue.main.async() {
            [unowned self] in
            self.performSegue(withIdentifier: "multiWaitingSegue", sender: self)
        }

    }
    
    func prepareView(){
        backgroundImage.layer.borderWidth = 2
        backgroundImage.layer.borderColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0).cgColor
        txtP1Name.layer.borderWidth = 1
        txtP1Name.layer.borderColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0).cgColor
        symbolSeg.isEnabled = false
        //txtP1Name.text = UserDefaults.standard.string(forKey: "p1Name")
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

}
