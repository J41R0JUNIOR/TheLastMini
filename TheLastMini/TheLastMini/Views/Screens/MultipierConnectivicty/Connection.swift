////
////  Connection.swift
////  TheLastMini
////
////  Created by Jairo Júnior on 09/08/24.
////
//
//import Foundation
//import MultipeerConnectivity
//
//class Connection: UIViewController{
//    let peer: MCPeerID
//    let session: MCSession
//    let serviceType: String
//    let browser: MCNearbyServiceBrowser
//    let browserController: MCBrowserViewController
//    let serviceAdvertiser: MCNearbyServiceAdvertiser
//    
//    init(){
//        peer = MCPeerID(displayName: "testSession")
//        session = MCSession(peer: peer)
//        serviceType = "service"
//        browser = MCNearbyServiceBrowser(peer: peer, serviceType: serviceType)
//        browserController = MCBrowserViewController(browser: browser, session: session)
//        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: nil, serviceType: serviceType)
//        
//        super.init(nibName: nil, bundle: nil)
//        
//        self.session.delegate = self
//        self.serviceAdvertiser.delegate = self
//        self.serviceAdvertiser.startAdvertisingPeer()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//extension Connection: MCSessionDelegate{
//    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
//        switch state{
//        case .connected: 
//            
//            break
//        case .notConnected: break
//            
//        case .connecting: break
//            
//        @unknown default: break
//            
//        }
//    }
//    
//    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//        <#code#>
//    }
//    
//    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
//        <#code#>
//    }
//    
//    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
//        <#code#>
//    }
//    
//    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
//        <#code#>
//    }
//}
//
//extension Connection: MCNearbyServiceBrowserDelegate{
//    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
//        <#code#>
//    }
//    
//    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
//        <#code#>
//    }
//}
//
//extension Connection: MCNearbyServiceAdvertiserDelegate{
//    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
//        <#code#>
//    }
//    
//    
//}
