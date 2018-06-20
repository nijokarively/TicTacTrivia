//
//  MultiModeSelectionViewController.swift
//  TicTacTrivia
//
//  Created by nijo on 07/04/2018.
//  Copyright © 2018 Nijo. All rights reserved.
//

import UIKit
import MultipeerConnectivity

let kMCSessionMaximumNumberOfPeers = 2

class MultiModeSelectionViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    var appDelegate  : AppDelegate!
    
    var peerID:MCPeerID!
    var mcSession:MCSession!
    var mcAdvertiserAssistant:MCAdvertiserAssistant!

    @IBOutlet weak var premiumImage: UIImageView!
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onlineButtonPressed(_ sender: Any) {
        UserDefaults.standard.set(3, forKey: "gameMode")
        DispatchQueue.main.async() {
            [unowned self] in
            self.performSegue(withIdentifier: "multiNetOptionsSegue", sender: self)
        }
//        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "t3-game", discoveryInfo: nil, session: mcSession)
//        mcAdvertiserAssistant.start()
    }
    
    @IBAction func joinSessionButtonClicked(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "MultiPeer Game", message: "Do you want to Host or Join a session?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Host Session", style: .default, handler: { action in self.mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "t3-game", discoveryInfo: nil, session: self.mcSession)
            self.mcAdvertiserAssistant.start()
            
            DispatchQueue.main.asyncAfter (deadline: .now() + 3.0){
                let alert = UIAlertController(title: "Unlock this feature now!", message: "Buy the PRO edition to unlock it!", preferredStyle: .alert);
                alert.addAction(UIAlertAction(title: "Buy now", style: .default, handler:{action in self.mcAdvertiserAssistant.stop()
                    self.goToShop()
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{action in self.mcAdvertiserAssistant.stop()
                }))
                alert.view.tintColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0)
                self.present(alert, animated: true);
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Join Session", style: .default, handler: { action in
            let mcBrowser = MCBrowserViewController(serviceType: "t3-game", session: self.mcSession)
            mcBrowser.maximumNumberOfPeers = 2
            mcBrowser.delegate = self
            self.present(mcBrowser, animated: true, completion: nil)

        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.view.tintColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0)
        self.present(actionSheet, animated: true, completion: nil)
                
    }
    
    func setupConnectivity(){
        peerID = MCPeerID(displayName: UIDevice.current.name)
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession.delegate = self
    }
    
    func goToShop(){
        if let url = URL(string: "itms-apps://itunes.apple.com/app/"),
        UIApplication.shared.canOpenURL(url)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        
    }
    
    func joinSessionAlert(){
        
        let alert = UIAlertController(title: "Unlock this feature now!", message: "Buy the PRO edition to unlock it!", preferredStyle: .alert);
        alert.addAction(UIAlertAction(title: "Buy now", style: .default, handler:{action in
            self.goToShop()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        alert.view.tintColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0)
        self.present(alert, animated: true);
        
        
        
    }
    
    @IBOutlet weak var btnOnline: UIButton!
    
    @IBOutlet weak var btnMultiPeer: UIButton!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    func prepareView(){
        backgroundImage.layer.borderWidth = 2
        backgroundImage.layer.borderColor = UIColor(red: (233.0/255.0), green: (30.0/255.0), blue: (99.0/255.0), alpha: 1.0).cgColor
        btnOnline.layer.cornerRadius = 26
        btnOnline.clipsToBounds = true
        btnMultiPeer.layer.cornerRadius = 26
        btnMultiPeer.clipsToBounds = true
        premiumImage.transform = premiumImage.transform.rotated(by: CGFloat(Double.pi/6))
        
    }
    
    // Multipeer functions
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
        case MCSessionState.notConnected:
            print ("Not Connected: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        self.dismiss(animated: true, completion: nil)
        joinSessionAlert()
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        self.dismiss(animated: true, completion: nil)
        joinSessionAlert()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConnectivity()
        prepareView()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
