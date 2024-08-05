//
//  ConnectionView.swift
//  TheLastMini
//
//  Created by Jairo Júnior on 03/08/24.
//

import Foundation
import UIKit
import MultipeerConnectivity

class ConnectionView: UIViewController{
    let peerId: MCPeerID
    let session: MCSession
    let serviceBrowser: MCNearbyServiceBrowser
    let browserView: MCBrowserViewController
    let serviceAdvertiser: MCNearbyServiceAdvertiser
    let serviceType = "video-peer"
    
    var joinButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .red
        button.setTitle("join", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var hostButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .red
        button.setTitle("host", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        self.peerId = .init(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerId)
        self.serviceBrowser = .init(peer: peerId, serviceType: self.serviceType)
        self.browserView = .init(browser: serviceBrowser, session: session)
        self.serviceAdvertiser = .init(peer: peerId, discoveryInfo: nil, serviceType: self.serviceType)
        
        super.init(nibName: nil, bundle: nil)
        
        self.session.delegate = self
        self.serviceAdvertiser.delegate = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
//       showBrowserView()
        self.addButtons()
    }
    
    func addButtons(){
        joinButton.addTarget(self, action: #selector(showBrowserView), for: .touchUpInside)
        hostButton.addTarget(self, action: #selector(showGameView), for: .touchUpInside)


        self.view.addSubview(joinButton)
        self.view.addSubview(hostButton)
        
        NSLayoutConstraint.activate([
            joinButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            joinButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            hostButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            hostButton.topAnchor.constraint(equalTo: self.joinButton.bottomAnchor)
        ])
    }
    
    func stopAdvertising() {
        self.serviceAdvertiser.stopAdvertisingPeer()
    }
    
    func startAdvertising() {
        self.serviceAdvertiser.startAdvertisingPeer()
    }
    
    
    @objc func showBrowserView(){
        self.browserView.delegate = self
        present(self.browserView, animated: true)
    }
    
    @objc func showGameView() {
        stopAdvertising()
       
        startAdvertising()
        
        let gameView = GameView(session: self.session)
        gameView.modalPresentationStyle = .fullScreen
        present(gameView, animated: true)
    }
}

//extension ConnectionView: MCNearbyServiceBrowserDelegate{
//    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
//        <#code#>
//    }
//    
//    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
//        <#code#>
//    }
//}

extension ConnectionView: MCNearbyServiceAdvertiserDelegate{
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("acho que eu vi um gatinhoooo! \(peerID)")
        invitationHandler(true, session)
    }
}

extension ConnectionView: MCBrowserViewControllerDelegate{
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true) {
            self.showGameView()
        }
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
}

extension ConnectionView: MCSessionDelegate{
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
            DispatchQueue.main.async {
                self.showGameView()
            }
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
        @unknown default:
            fatalError("Unknown state")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
    }
}
