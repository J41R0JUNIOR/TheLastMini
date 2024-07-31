//
//  GamePlayViewController.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 22/07/24.
//

import UIKit
import ARKit
import SceneKit

class GamePlayViewController: UIViewController {
    
    private lazy var sceneView: ARSCNView = {
        let arView = ARSCNView()
        arView.translatesAutoresizingMaskIntoConstraints = false
        return arView
    }()
    
    ///View de animacao de scan
    private lazy var coachingOverlay: ARCoachingOverlayView = {
        let arView = ARCoachingOverlayView()
        arView.translatesAutoresizingMaskIntoConstraints = false
        return arView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViewCode()
        self.setupConfigurations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}


extension GamePlayViewController: ViewCode{
    func addViews() {
        self.view.addListSubviews(sceneView, coachingOverlay)
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: self.view.topAnchor),
            sceneView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            sceneView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            coachingOverlay.topAnchor.constraint(equalTo: self.view.topAnchor),
            coachingOverlay.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            coachingOverlay.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            coachingOverlay.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func setupStyle() {
        
    }
}

extension GamePlayViewController: ARSCNViewDelegate{
    private func setupConfigurations(){
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = [.showWorldOrigin, .showPhysicsShapes]
        
        coachingOverlay.session = sceneView.session
        coachingOverlay.delegate = self
        coachingOverlay.goal = .anyPlane
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh){
            configuration.sceneReconstruction = .mesh
        }
        
        sceneView.session.run(configuration)
        
    }
}


//MARK: - Configuração de animação de scan
extension GamePlayViewController: ARCoachingOverlayViewDelegate{
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print("Vai comecar ✅")
    }
    
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print("Sera que foi agora? 🐐")
    }
    
    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
        print("Pedi para refazer  🚨")
    }
}
