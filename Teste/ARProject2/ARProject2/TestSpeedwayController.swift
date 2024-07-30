//
//  TestSpeedwayController.swift
//  ARProject2
//
//  Created by André Felipe Chinen on 30/07/24.
//

import SceneKit
import ARKit
import UIKit

class TestSpeedwayController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate, ARCoachingOverlayViewDelegate {
    var sessionInfoView: UIView!
    var sessionInfoLabel: UILabel!
    
    var sceneView: ARSCNView!
    var vehicleNode: SCNNode!
    var vehicle: SCNPhysicsVehicle!
    var isVehicleAdded = false
    var isPlaneAdded = false
    
    var groundNode: SCNNode?
    var invWall1: SCNNode?
    var invWall2: SCNNode?
    
    var coachingOverlay = ARCoachingOverlayView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
//        setupVehicle()
//        setupControls()
        setupCoachingOverlay()
        
    }
    
    func setupScene() {
        sceneView = ARSCNView(frame: self.view.frame)
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = [/*.showWorldOrigin,*/ .showPhysicsShapes]
        self.view.addSubview(sceneView)
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        // Configura a sessão de AR
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        sceneView.addGestureRecognizer(gestureRecognizer)
        
        
//        let floor = SCNFloor()
//        let floorNode = SCNNode(geometry: floor)
//        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: floor, options: nil))
//        sceneView.scene.rootNode.addChildNode(floorNode)
//        floorNode.geometry?.materials.first?.diffuse.contents = UIColor.blue.withAlphaComponent(0.7)
//        floorNode.position = SCNVector3(x: 0, y: -1, z: 0)
    }
    
    
    // Função para criar uma roda a partir do asset usdz
    func createWheel() -> SCNNode {
        guard let wheelScene = SCNScene(named: "wheelCilindro.usdz"),
              let wheelNode = wheelScene.rootNode.childNodes.first else {
            fatalError("Could not load wheel asset")
        }
        
        
        return wheelNode.clone()
    }
    
    func createChassis() ->SCNNode{
        guard let chassis = SCNScene(named: "chassiModel.usdz"),
              let chassisNode = chassis.rootNode.childNodes.first else {
            fatalError("Could not load wheel asset")
        }
        return chassisNode
    }
    
    func createPista() ->SCNNode{
        guard let pista = SCNScene(named: "speedway.usdz"),
              let pistaNode = pista.rootNode.childNodes.first else {
            fatalError("Could not load wheel asset")
        }
        
        guard let nodes = pista.rootNode.childNodes.first else { fatalError() }
        
        groundNode = nodes.childNode(withName: "Ground", recursively: true)
        invWall1 = nodes.childNode(withName: "InvWall1", recursively: true)
        invWall1?.geometry?.materials.first?.diffuse.contents = UIColor.green.withAlphaComponent(0.5)
        invWall2 = nodes.childNode(withName: "InvWall2", recursively: true)
        invWall2?.geometry?.materials.first?.diffuse.contents = UIColor.green.withAlphaComponent(0.5)
        
        return pistaNode
    }
    
    func setupVehicle(at position: SCNVector3) {
        // Cria o chassis do veículo
        let chassisNode = createChassis()
        chassisNode.position = position
        
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: chassisNode, options: [SCNPhysicsShape.Option.keepAsCompound: true]))
        body.mass = 1.0
        chassisNode.physicsBody = body
        
        // Cria as rodas e ajusta suas posições
        let wheel1Node = createWheel()
        wheel1Node.position = SCNVector3(-0.5, 0, 0.75)
        
        let wheel2Node = createWheel()
        wheel2Node.position = SCNVector3(0.5, 0, 0.75)

        let wheel3Node = createWheel()
        wheel3Node.position = SCNVector3(-0.5, 0, -0.75)

        let wheel4Node = createWheel()
        wheel4Node.position = SCNVector3(0.5, 0, -0.75)

        // Adiciona as rodas ao nó pai
        chassisNode.addChildNode(wheel1Node)
        chassisNode.addChildNode(wheel2Node)
        chassisNode.addChildNode(wheel3Node)
        chassisNode.addChildNode(wheel4Node)
        
        // Cria juntas para conectar as rodas ao chassi
        let wheel1 = SCNPhysicsVehicleWheel(node: wheel1Node)
        let wheel2 = SCNPhysicsVehicleWheel(node: wheel2Node)
        let wheel3 = SCNPhysicsVehicleWheel(node: wheel3Node)
        let wheel4 = SCNPhysicsVehicleWheel(node: wheel4Node)
        
        wheel1.connectionPosition = SCNVector3(-0.32, -0.15, 0.45)
        wheel2.connectionPosition = SCNVector3(0.32, -0.15, 0.45)
        wheel3.connectionPosition = SCNVector3(-0.32, -0.15, -0.45)
        wheel4.connectionPosition = SCNVector3(0.32, -0.15, -0.45)
        
        wheel1.suspensionStiffness = CGFloat(1)
        wheel2.suspensionStiffness = CGFloat(1)
        wheel3.suspensionStiffness = CGFloat(1)
        wheel4.suspensionStiffness = CGFloat(1)
        
        let vehicle = SCNPhysicsVehicle(chassisBody: body, wheels: [wheel1, wheel2, wheel3, wheel4])
        
        self.vehicle = vehicle
        self.vehicleNode = chassisNode
        
        // Adiciona o veículo à cena
        self.sceneView.scene.rootNode.addChildNode(self.vehicleNode)
        
        // Adiciona o comportamento do veículo após a configuração
        self.sceneView.scene.physicsWorld.addBehavior(self.vehicle)
        
        
        isVehicleAdded = true
    }
    
    func setupControls() {
        // Adicionar controles de movimento
        
        // Botões de direção lado a lado na esquerda
        let leftButton = UIButton(frame: CGRect(x: 20, y: self.view.frame.height - 120, width: 100, height: 50))
        leftButton.backgroundColor = .green
        leftButton.setTitle("Left", for: .normal)
        leftButton.addTarget(self, action: #selector(turnLeft), for: .touchDown)
        leftButton.addTarget(self, action: #selector(resetOrientation), for: .touchUpInside)
        self.view.addSubview(leftButton)
        
        let rightButton = UIButton(frame: CGRect(x: 130, y: self.view.frame.height - 120, width: 100, height: 50))
        rightButton.backgroundColor = .yellow
        rightButton.setTitle("Right", for: .normal)
        rightButton.addTarget(self, action: #selector(turnRight), for: .touchDown)
        rightButton.addTarget(self, action: #selector(resetOrientation), for: .touchUpInside)
        self.view.addSubview(rightButton)
        
        // Botões de movimento um acima do outro na direita
        let forwardButton = UIButton(frame: CGRect(x: self.view.frame.width - 120, y: self.view.frame.height - 180, width: 100, height: 50))
        forwardButton.backgroundColor = .blue
        forwardButton.setTitle("Forward", for: .normal)
        forwardButton.addTarget(self, action: #selector(moveForward), for: .touchDown)
        forwardButton.addTarget(self, action: #selector(resetSpeed), for: .touchUpInside)
        self.view.addSubview(forwardButton)
        
        let backwardButton = UIButton(frame: CGRect(x: self.view.frame.width - 120, y: self.view.frame.height - 120, width: 100, height: 50))
        backwardButton.backgroundColor = .red
        backwardButton.setTitle("Backward", for: .normal)
        backwardButton.addTarget(self, action: #selector(moveBackward), for: .touchDown)
        backwardButton.addTarget(self, action: #selector(resetSpeed), for: .touchUpInside)
        self.view.addSubview(backwardButton)
    }
    
    func setupCoachingOverlay() {
        coachingOverlay.session = sceneView.session
        coachingOverlay.delegate = self
        coachingOverlay.goal = .anyPlane
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(coachingOverlay)
        
        // Constrains para garantir que o overlay cubra toda a tela
        NSLayoutConstraint.activate([
            coachingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            coachingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coachingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coachingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print("Vai comecar ✅")
    }
    
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print("Sera que foi agora? 🐐")
    }
    
    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
        print("Pedi para refazer  🚨")
    }
    
    
    @objc func moveForward() {
        let force: CGFloat = 1 // Aumentar a força aplicada
        vehicle.applyEngineForce(force, forWheelAt: 2) // Traseiras
        vehicle.applyEngineForce(force, forWheelAt: 3)
    }
    
    @objc func moveBackward() {
        let force: CGFloat = -1 // Aumentar a força aplicada
        vehicle.applyEngineForce(force, forWheelAt: 2) // Traseiras
        vehicle.applyEngineForce(force, forWheelAt: 3)
    }
    
    @objc func turnRight() {
        vehicle.setSteeringAngle(-0.5, forWheelAt: 0) // Dianteiras
        vehicle.setSteeringAngle(-0.5, forWheelAt: 1)
    }
    
    @objc func turnLeft() {
        vehicle.setSteeringAngle(0.5, forWheelAt: 0) // Dianteiras
        vehicle.setSteeringAngle(0.5, forWheelAt: 1)
    }
    
    @objc func resetOrientation(){
        vehicle.setSteeringAngle(0.0, forWheelAt: 0)
        vehicle.setSteeringAngle(0.0, forWheelAt: 1)
    }
    
    @objc func resetSpeed(){
        let force: CGFloat = 0 // Aumentar a força aplicada
        vehicle.applyEngineForce(force, forWheelAt: 2) // Traseiras
        vehicle.applyEngineForce(force, forWheelAt: 3)
    }
    
    func addFloor(hitTestResult: ARRaycastResult) {
        if isPlaneAdded {
            return
        }
        
        isPlaneAdded = true
        
        let floor = SCNFloor()
        let floorNode = SCNNode(geometry: floor)
        floorNode.geometry = floor
        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: floor, options: nil))
        floorNode.geometry?.materials.first?.diffuse.contents = UIColor.blue.withAlphaComponent(0.0)
        floorNode.position = SCNVector3(hitTestResult.worldTransform.columns.3.x, hitTestResult.worldTransform.columns.3.y, hitTestResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(floorNode)
        
        let speedwayNode = createPista()
        let body = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: speedwayNode, options: [SCNPhysicsShape.Option.keepAsCompound: true]))
        speedwayNode.physicsBody = body
        speedwayNode.position = SCNVector3(x: hitTestResult.worldTransform.columns.3.x, y: hitTestResult.worldTransform.columns.3.y, z: hitTestResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(speedwayNode)
        
        setupVehicle(at: SCNVector3(hitTestResult.worldTransform.columns.3.x, hitTestResult.worldTransform.columns.3.y, hitTestResult.worldTransform.columns.3.z))
        setupControls()
        
    }
    
    @objc func tapped(gesture: UITapGestureRecognizer) {
        // Get exact position where touch happened on screen of iPhone (2D coordinate)
        let touchPosition = gesture.location(in: sceneView)
        // 2.
        guard let query = sceneView.raycastQuery(from: touchPosition, allowing: .existingPlaneInfinite, alignment: .any) else {
            return
        }
        
        let results = sceneView.session.raycast(query)
        guard let hitResult = results.first else {
            print("No surface found")
            return
        }
        
        addFloor(hitTestResult: hitResult)
    }
    
    // Métodos de ARSCNViewDelegate para gerenciar a detecção de planos e atualização de nós
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Implementar se necessário
        print("RENDERER FUNCTION!!!!!!!!!!!")
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        print("Contact happened!")
    }
}

