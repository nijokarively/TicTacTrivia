//
//  MCHandler.swift
//  TicTacTrivia
//
//  Created by nijo on 23/04/2018.
//  Copyright © 2018 Nijo. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity

class MCHandler: NSObject, MCSessionDelegate  {
    var peerID:MCPeerID!
    var session:MCSession!
    var browserController:MCBrowserViewController!
    var advertiser:MCAdvertiserAssistant? = nil

    let serviceType:String = "t3-game"
    
    func setupPeerWithDisplayName(displayName: String) {
        peerID = MCPeerID(displayName: UIDevice.current.name)
    }
    
    func setupSession() {
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
    }
    
    func setupBrowser() {
        browserController = MCBrowserViewController(serviceType: serviceType, session: session)
        browserController.maximumNumberOfPeers = 2
    }
    
    func connectToPeer(connectPeerID: MCPeerID) {
        if self.peerID.displayName > connectPeerID.displayName {
            browserController.browser?.invitePeer(connectPeerID, to: self.session, withContext: nil, timeout: 10)
        }
    }
    
    func advertiseSelf(advertise:Bool){
        if advertise {
            advertiser = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: session)
            advertiser?.start()
        } else {
            advertiser?.stop()
            advertiser = nil
        }
    }
    
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

}
