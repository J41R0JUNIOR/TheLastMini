import SceneKit
import ARKit
import UIKit

class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate, ARCoachingOverlayViewDelegate {
    var sessionInfoView: UIView!
    var sessionInfoLabel: UILabel!
    
    var sceneView: ARSCNView!
    var vehicleNode: SCNNode!
    var vehicle: SCNPhysicsVehicle!
    var isVehicleAdded = false
    var isPlaneAdded = false
    var pinchGesture = UIPinchGestureRecognizer()
    
    var wheel1Node: SCNNode!
    var wheel2Node: SCNNode!
    var wheel3Node: SCNNode!
    var wheel4Node: SCNNode!
    
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
        
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(sender:)))
        
        sceneView.addGestureRecognizer(pinchGesture)
        
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
//        chassisNode.position = SCNVector3(0, -1, -5)
        return chassisNode
    }
    
    func setupVehicle(at position: SCNVector3) {
        // Nó pai para agrupar chassi e rodas
        let vehicleNode = SCNNode()
        vehicleNode.position = position
        
        // Cria o chassis do veículo
        let chassisNode = createChassis()
        chassisNode.position = SCNVector3(0, 0.25, 0) // Ajuste conforme necessário
        
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: chassisNode, options: [SCNPhysicsShape.Option.keepAsCompound: true]))
        body.mass = 1.0
        chassisNode.physicsBody = body
        
        // Cria as rodas e ajusta suas posições
        wheel1Node = createWheel()
        wheel1Node.position = SCNVector3(-0.5, 0, 0.75)
        
        wheel2Node = createWheel()
        wheel2Node.position = SCNVector3(0.5, 0, 0.75)
        
        wheel3Node = createWheel()
        wheel3Node.position = SCNVector3(-0.5, 0, -0.75)
        
        wheel4Node = createWheel()
        wheel4Node.position = SCNVector3(0.5, 0, -0.75)
        
        // Adiciona as rodas ao nó pai
        chassisNode.addChildNode(wheel1Node)
        chassisNode.addChildNode(wheel2Node)
        chassisNode.addChildNode(wheel3Node)
        chassisNode.addChildNode(wheel4Node)
        vehicleNode.addChildNode(chassisNode)
        
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
        self.vehicleNode = vehicleNode
        
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
        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: floor, options: nil))
        floorNode.geometry?.materials.first?.diffuse.contents = UIColor.blue.withAlphaComponent(0.7)
        floorNode.position = SCNVector3(hitTestResult.worldTransform.columns.3.x, hitTestResult.worldTransform.columns.3.y, hitTestResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(floorNode)
        
        setupVehicle(at: SCNVector3(hitTestResult.worldTransform.columns.3.x, hitTestResult.worldTransform.columns.3.y - 2, hitTestResult.worldTransform.columns.3.z))
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
    
    @objc func handlePinch(sender: UIPinchGestureRecognizer) {
        let scale = Float(sender.scale)
        
//        if sender.state == .began {
//            self.sceneView.scene.physicsWorld.removeBehavior(self.vehicle)
//        }
        
        // Ajusta a escala do nó pai
        vehicleNode.scale = SCNVector3(x: vehicleNode.scale.x * scale, y: vehicleNode.scale.y * scale, z: vehicleNode.scale.z * scale)
        
        if sender.state == .ended {
//            // Recria a forma física do chassi para refletir a nova escala
            if let chassisNode = vehicleNode.childNodes.first {
//                self.sceneView.scene.physicsWorld.removeBehavior(self.vehicle)
//                chassisNode.physicsBody = nil
//                wheel1Node.physicsBody = nil
//                wheel2Node.physicsBody = nil
//                wheel3Node.physicsBody = nil
//                wheel4Node.physicsBody = nil
                let newBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: chassisNode, options: [SCNPhysicsShape.Option.keepAsCompound: true]))
                newBody.mass = 1.0
                chassisNode.physicsBody = newBody
//                
//                let shapeScale = NSValue(scnVector3: SCNVector3(x: chassisNode.scale.x, y: chassisNode.scale.y, z: chassisNode.scale.z))
//                let shapeOptions: [SCNPhysicsShape.Option: Any] = [.scale: shapeScale]
//                
//                let physicShape = SCNPhysicsShape(node: chassisNode, options: shapeOptions)
//                
//                chassisNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: physicShape)
//                
//                let shapeScaleWheel = NSValue(scnVector3: SCNVector3(x: wheel1Node.scale.x, y: wheel1Node.scale.y, z: wheel1Node.scale.z))
//                let shapeOptionsWheel: [SCNPhysicsShape.Option: Any] = [.scale: shapeScaleWheel]
//                
//                let physicShapeWheel1 = SCNPhysicsShape(node: wheel1Node, options: shapeOptionsWheel)
//                let physicShapeWheel2 = SCNPhysicsShape(node: wheel2Node, options: shapeOptionsWheel)
//                let physicShapeWheel3 = SCNPhysicsShape(node: wheel3Node, options: shapeOptionsWheel)
//                let physicShapeWheel4 = SCNPhysicsShape(node: wheel4Node, options: shapeOptionsWheel)
//                
//                wheel1Node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: physicShapeWheel1)
//                wheel2Node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: physicShapeWheel2)
//                wheel3Node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: physicShapeWheel3)
//                wheel4Node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: physicShapeWheel4)
                
//
//                let wheel1 = SCNPhysicsVehicleWheel(node: wheel1Node)
//                let wheel2 = SCNPhysicsVehicleWheel(node: wheel2Node)
//                let wheel3 = SCNPhysicsVehicleWheel(node: wheel3Node)
//                let wheel4 = SCNPhysicsVehicleWheel(node: wheel4Node)
//                
//                wheel1.connectionPosition = SCNVector3(-0.32, -0.15, 0.45)
//                wheel2.connectionPosition = SCNVector3(0.32, -0.15, 0.45)
//                wheel3.connectionPosition = SCNVector3(-0.32, -0.15, -0.45)
//                wheel4.connectionPosition = SCNVector3(0.32, -0.15, -0.45)
//                
//                wheel1.suspensionStiffness = CGFloat(1)
//                wheel2.suspensionStiffness = CGFloat(1)
//                wheel3.suspensionStiffness = CGFloat(1)
//                wheel4.suspensionStiffness = CGFloat(1)
//                
//                let vehicle = SCNPhysicsVehicle(chassisBody: newBody, wheels: [wheel1, wheel2, wheel3, wheel4])
//                
//                self.vehicle = vehicle
//                
//                self.sceneView.scene.physicsWorld.addBehavior(self.vehicle)
            }
        }
        
        // Resetando a escala do gesture recognizer para 1 após aplicar a transformação
        sender.scale = 1
    }
    
    // Métodos de ARSCNViewDelegate para gerenciar a detecção de planos e atualização de nós
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Implementar se necessário
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        print("Contact happened!")
    }
}
