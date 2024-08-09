//
//  Connection.swift
//  TheLastMini
//
//  Created by Jairo Júnior on 09/08/24.
//

import Foundation
import MultipeerConnectivity

class Connection{
    let peer: MCPeerID
    let session: MCSession
    let serviceType: String
    let browser: MCNearbyServiceBrowser
    let browserController: MCBrowserViewController
    let serviceAdvertiser: MCNearbyServiceAdvertiser
    
    init(){
        peer = MCPeerID(displayName: "testSession")
        session = MCSession(peer: peer)
        serviceType = "service"
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: serviceType)
        browserController = MCBrowserViewController(browser: browser, session: session)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: serviceType)
    }
}
