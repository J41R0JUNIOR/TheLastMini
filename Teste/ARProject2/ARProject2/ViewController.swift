import SceneKit
import ARKit
import UIKit

class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {
    
    var sceneView: ARSCNView!
    var vehicleNode: SCNNode!
    var vehicle: SCNPhysicsVehicle!
    var isVehicleAdded = false
    var isPlaneAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        setupVehicle()
        setupControls()
    }
    
    func setupScene() {
        sceneView = ARSCNView(frame: self.view.frame)
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = [.showWorldOrigin, .showPhysicsShapes]
        self.view.addSubview(sceneView)
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        // Configura a sessão de AR
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        
        let floor = SCNFloor()
        let floorNode = SCNNode(geometry: floor)
        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: floor, options: nil))
        sceneView.scene.rootNode.addChildNode(floorNode)
        floorNode.geometry?.materials.first?.diffuse.contents = UIColor.blue.withAlphaComponent(0.7)
    }
    
    
    
    func setupVehicle() {
        // Cria o chassis do veículo
//        let chassis = SCNBox(width: 1.0, height: 0.5, length: 2.0, chamferRadius: 0.0)
//        let chassisNode = SCNNode(geometry: chassis)
//        chassisNode.position = SCNVector3(0, 0.5, -5)
        
        guard let wheelScene = SCNScene(named: "wheel.usdz"),
              let wheelNode = wheelScene.rootNode.childNodes.first else {
            fatalError("Could not load wheel asset")
        }
        
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: chassisNode, options: [SCNPhysicsShape.Option.keepAsCompound: true]))
        body.mass = 1.0
        chassisNode.physicsBody = body
        
        // Função para criar uma roda a partir do asset usdz
        func createWheel() -> SCNNode {
            guard let wheelScene = SCNScene(named: "wheel.usdz"),
                  let wheelNode = wheelScene.rootNode.childNodes.first else {
                fatalError("Could not load wheel asset")
            }
            
            return wheelNode.clone()
        }
        
        let wheel1Node = createWheel()
        wheel1Node.position = SCNVector3(-0.5, 0, 0.75)
        
        let wheel2Node = createWheel()
        wheel2Node.position = SCNVector3(0.5, 0, 0.75)
        
        let wheel3Node = createWheel()
        wheel3Node.position = SCNVector3(-0.5, 0, -0.75)
        
        let wheel4Node = createWheel()
        wheel4Node.position = SCNVector3(0.5, 0, -0.75)
        
        // Cria juntas para conectar as rodas ao chassi
        let wheel1 = SCNPhysicsVehicleWheel(node: wheel1Node)
        let wheel2 = SCNPhysicsVehicleWheel(node: wheel2Node)
        let wheel3 = SCNPhysicsVehicleWheel(node: wheel3Node)
        let wheel4 = SCNPhysicsVehicleWheel(node: wheel4Node)
        
        wheel1.connectionPosition = SCNVector3(-0.5, -0.25, 0.75)
        wheel2.connectionPosition = SCNVector3(0.5, -0.25, 0.75)
        wheel3.connectionPosition = SCNVector3(-0.5, -0.25, -0.75)
        wheel4.connectionPosition = SCNVector3(0.5, -0.25, -0.75)
        
        wheel1.suspensionStiffness = CGFloat(1)
        wheel2.suspensionStiffness = CGFloat(1)
        wheel3.suspensionStiffness = CGFloat(1)
        wheel4.suspensionStiffness = CGFloat(1)
        
        chassisNode.addChildNode(wheel1Node)
        chassisNode.addChildNode(wheel2Node)
        chassisNode.addChildNode(wheel3Node)
        chassisNode.addChildNode(wheel4Node)
        
        let vehicle = SCNPhysicsVehicle(chassisBody: body, wheels: [wheel1, wheel2, wheel3, wheel4])
        
        sceneView.scene.rootNode.addChildNode(chassisNode)
        
        SCNTransaction.begin()
        SCNTransaction.completionBlock = {
            self.sceneView.scene.physicsWorld.addBehavior(vehicle)
            self.vehicle = vehicle
            self.vehicleNode = chassisNode
        }
        SCNTransaction.commit()
        
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
    
    // Métodos de ARSCNViewDelegate para gerenciar a detecção de planos e atualização de nós
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Implementar se necessário
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        print("Contact happened!")
    }
}
