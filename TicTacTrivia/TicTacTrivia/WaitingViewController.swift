//
//  WaitingViewController.swift
//  TicTacTrivia
//
//  Created by nijo on 22/04/2018.
//  Copyright © 2018 Nijo. All rights reserved.
//

import UIKit

class WaitingViewController: UIViewController {

    @IBOutlet weak var btnCancel: UIButton!
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.deleteSession(name: self.playerName)
        stopTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            [unowned self] in
            self.performSegue(withIdentifier: "backToMainUnwindSegue", sender: self)
            
        }
    }
    
    var onlineSessionID = ""
    var playerName = ""
    var opponentName = ""
    var timer = Timer()

    
    func getSession(){
        let kPathURL = "http://localhost/GetGameSession.php"
        
        let request = URL(string: kPathURL)!
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if error != nil
            {
                print ("ERROR")
            }
            else
            {
                if let content = data
                {
                    
                    do
                    {
                        let jsonResult = try JSONSerialization.jsonObject(with: content, options: .mutableContainers) as! NSArray
                        if jsonResult.count == 0 {
                             self.createSession(name: self.playerName)
                            UserDefaults.standard.set(1, forKey: "onlineStatus")
                            self.startTimer()
                        } else {
                        
                            let tempArray = jsonResult.value(forKey: "sessionFull") as! Array<String>
                            let sessionStatus = Int(tempArray[0])!
                            if sessionStatus == 0 {
                                let tempArray2 = jsonResult.value(forKey: "sessionID") as! Array<String>
                                self.onlineSessionID = tempArray2[0]
                                self.setSession(name: self.playerName, sessionID: self.onlineSessionID)
                                UserDefaults.standard.set(2, forKey: "onlineStatus")
                                let tempArray3 = jsonResult.value(forKey: "p1Name") as! Array<String>
                                self.opponentName = tempArray3[0]
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    self.goToGame()
                                }
                                
                            } else if sessionStatus == 1 {
                                self.createSession(name: self.playerName)
                                UserDefaults.standard.set(1, forKey: "onlineStatus")
                                self.startTimer()
                            }
                            //print(self.session)
                            
                        }
                    }
                    catch
                    {
                    }
                }
            }
        }
        task.resume();
    }
    
    var isCompleted:Bool = false
    
    @objc func checkOpponentReady(){
        getSessionCompleteStatus()
                // do second task if success
        if isCompleted {
            goToGame()
        }
        
        
    }
    
    func saveUserDetails(){
        if UserDefaults.standard.integer(forKey: "onlineStatus") == 1{
            UserDefaults.standard.set(playerName, forKey: "p1Name")
            UserDefaults.standard.set(opponentName, forKey: "p2Name")
        } else {
            UserDefaults.standard.set(opponentName, forKey: "p1Name")
            UserDefaults.standard.set(playerName, forKey: "p2Name")
        }
        UserDefaults.standard.set(onlineSessionID, forKey: "sessionID")
    }
    
    func goToGame(){
        saveUserDetails()
        createGameMove(id: onlineSessionID)
        stopTimer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            [unowned self] in
            self.performSegue(withIdentifier: "OnlineGameSessionSegue", sender: self)
        }
    }
    
    func startTimer(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(WaitingViewController.checkOpponentReady), userInfo: nil, repeats: true)
        }

    }
    
    func stopTimer(){
        timer.invalidate();
        timer = Timer();
    }
    
    func getSessionCompleteStatus(){
        let kPathURL = "http://localhost/GetGameSession.php"
        
        let request = URL(string: kPathURL)!
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if error != nil
            {
                print ("ERROR")
            }
            else
            {
                if let content = data
                {
                    
                    do
                    {
                        let jsonResult = try JSONSerialization.jsonObject(with: content, options: .mutableContainers) as! NSArray
                        
                        let tempArray = jsonResult.value(forKey: "sessionFull") as! Array<String>
                        let tempNameArray = jsonResult.value(forKey: "p2Name") as! Array<String>
                        let tempSessionArray = jsonResult.value(forKey: "sessionID") as! Array<String>
                        
                        let sessionStatus = Int(tempArray[0])!
                        if sessionStatus == 1 {
                            self.isCompleted = true
                            self.opponentName = tempNameArray[0]
                            self.onlineSessionID = tempSessionArray[0]
                        }

                        
                    }
                    catch
                    {
                    }
                }
            }
        }
        task.resume();
        
    }
    
    func setSession(name: String, sessionID: String){
        
        let kPathURL = "http://localhost/SetGameSession.php?name="+name+"&id="+sessionID
        
        let request = URL(string: kPathURL)!
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if error != nil
            {
                print ("ERROR")
            }
            else
            {
                if let content = data
                {
                    
                    do
                    {
                        let jsonResult = try JSONSerialization.jsonObject(with: content, options: .mutableContainers) as! NSArray
                        
                        print(jsonResult)
                    }
                    catch
                    {
                    }
                }
            }
        }
        task.resume();
    }
    
    func deleteSession(name: String){
        
        let kPathURL = "http://localhost/DeleteGameSession.php?name="+name
        
        let request = URL(string: kPathURL)!
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if error != nil
            {
                print ("ERROR")
            }
            else
            {
                if let content = data
                {
                    
                    do
                    {
                        let jsonResult = try JSONSerialization.jsonObject(with: content, options: .mutableContainers) as! NSArray
                        
                        print(jsonResult)
                    }
                    catch
                    {
                    }
                }
            }
        }
        task.resume();
    }
    
    func createSession(name: String){
        
        let kPathURL = "http://localhost/InsertGameSession.php?name="+name
        
        let request = URL(string: kPathURL)!
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if error != nil
            {
                print ("ERROR")
            }
            else
            {
                if let content = data
                {
                    
                    do
                    {
                        let jsonResult = try JSONSerialization.jsonObject(with: content, options: .mutableContainers) as! NSArray
                        
                        print(jsonResult)
                    }
                    catch
                    {
                    }
                }
            }
        }
        task.resume();
    }
  
    
    func createGameMove(id: String){
        
        let kPathURL = "http://localhost/InsertGameMove.php?id="+id
        
        let request = URL(string: kPathURL)!
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if error != nil
            {
                print ("ERROR")
            }
            else
            {
                if let content = data
                {
                    
                    do
                    {
                        let jsonResult = try JSONSerialization.jsonObject(with: content, options: .mutableContainers) as! NSArray
                        
                        print(jsonResult)
                    }
                    catch
                    {
                    }
                }
            }
        }
        task.resume();
    }
    
    
    func getUserData(){
        playerName = UserDefaults.standard.string(forKey: "onlineName")!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        getUserData()
        getSession()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareView(){
        btnCancel.layer.cornerRadius = 26
        btnCancel.clipsToBounds = true
    }


}
