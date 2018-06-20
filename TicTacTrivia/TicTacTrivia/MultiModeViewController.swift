//
//  MultiModeViewController.swift
//  TicTacTrivia
//
//  Created by nijo on 28/03/2018.
//  Copyright © 2018 Nijo. All rights reserved.
//

import UIKit

class MultiModeViewController: UIViewController {
    @IBOutlet var backgroundImage: UIImageView!
    
    @IBAction func backButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        // Do any additional setup after loading the view.
    }
    
    func prepareView(){
        backgroundImage.layer.borderWidth = 2
        backgroundImage.layer.borderColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0).cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func networkButtonClicked(_ sender: Any) {
        DispatchQueue.main.async() {
            [unowned self] in
            self.performSegue(withIdentifier: "multiSelectionSegue", sender: self)
        }
    }
    
    @IBAction func localButtonClicked(_ sender: Any) {
        DispatchQueue.main.async() {
            [unowned self] in
            self.performSegue(withIdentifier: "localOptionsSegue", sender: self)
        }
        
    }


}

