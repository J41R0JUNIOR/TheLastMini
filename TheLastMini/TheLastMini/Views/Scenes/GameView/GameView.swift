import Foundation
import ARKit

class GameView: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate, ARSessionDelegate, TrafficLightDelegate{

    var sceneView: ARSCNView!
    var isVehicleAdded = false
    
    var groundNode: SCNNode?
    var invWall1: SCNNode?
    var invWall2: SCNNode?
    
    var entities: [Entity] = []
    let movementSystem = MovementSystem()
    let renderSystem = RenderSystem()
    
    var trafficLightComponent = TrafficLightComponent(frame: .init(origin: .zero, size: .init(width: 200, height: 100)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        setupTapGesture()
        trafficLightComponent.delegate = self
    }

    
    func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: sceneView)
        guard let query = sceneView.raycastQuery(from: location, allowing: .existingPlaneGeometry, alignment: .horizontal) else { return }
        
        let results = sceneView.session.raycast(query)
        guard let hitTestResult = results.first else { return }
        
        let position = SCNVector3(x: hitTestResult.worldTransform.columns.3.x,
                                  y: hitTestResult.worldTransform.columns.3.y,
                                  z: hitTestResult.worldTransform.columns.3.z)
        
        print("Tapped position: \(position)")
        setupFloor(at: position)
    }
    
    func setupFloor(at position: SCNVector3){
        //        if isVehicleAdded {
        //            return
        //        }
        
        isVehicleAdded = true
        
        let floor = SCNFloor()
        let floorNode = SCNNode(geometry: floor)
        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: floor, options: nil))
        sceneView.scene.rootNode.addChildNode(floorNode)
        floorNode.geometry?.materials.first?.diffuse.contents = UIColor.blue.withAlphaComponent(0.0)
        floorNode.position = position
        floorNode.position.y -= 0.2
        
        let speedwayNode = createSpeedway()
        let body = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: speedwayNode, options: [SCNPhysicsShape.Option.keepAsCompound: true]))
        speedwayNode.physicsBody = body
        speedwayNode.position = position
        speedwayNode.position.y -= 0.1
        
        sceneView.scene.rootNode.addChildNode(speedwayNode)
        
        setupVehicle(at: position)
        setupControls()
        trafficLightComponent.lightAnimation()
        //        floorNode.position = SCNVector3(x: 0, y: -1, z: -4)
    }
    
    func setupScene() {
        sceneView = ARSCNView(frame: self.view.frame)
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = [.showPhysicsShapes]
        self.view.addSubview(sceneView)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        
//        SetupTrafficLight()
        trafficLightComponent.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(trafficLightComponent)
        
        NSLayoutConstraint.activate([
            trafficLightComponent.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trafficLightComponent.centerYAnchor.constraint(equalTo: view.centerYAnchor)
               ])
    }
    
    func createWheel(lado: Lado) -> SCNNode {
        let wheel = lado == .L ? "Ll.usdz" : "Rr.usdz"
        guard let wheelNode = SCNScene(named: wheel)?.rootNode else {
            fatalError("Could not load wheel asset")
        }
        return wheelNode.clone()
    }
    
    func createChassis() -> SCNNode {
        guard let chassis = SCNScene(named: "MmR.usdz"),
              let chassisNode = chassis.rootNode.childNodes.first else {
            fatalError("Could not load chassis asset")
        }
        return chassisNode
    }
    
    func createSpeedway() ->SCNNode{
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
        let chassisNode = createChassis()
        let body = SCNPhysicsBody(type: .dynamic, shape: nil)
        body.mass = 1.0
        chassisNode.physicsBody = body
        
        let wheel1Node = createWheel(lado: .R)
        
        let wheel2Node = createWheel(lado: .L)
        let wheel3Node = createWheel(lado: .R)
        let wheel4Node = createWheel(lado: .L)
        
        let wheel1 = SCNPhysicsVehicleWheel(node: wheel1Node)
        let wheel2 = SCNPhysicsVehicleWheel(node: wheel2Node)
        let wheel3 = SCNPhysicsVehicleWheel(node: wheel3Node)
        let wheel4 = SCNPhysicsVehicleWheel(node: wheel4Node)
        
        let x: Double = 0.19
        let y: Double = 0
        let z: Double = 0.25
        
        wheel1.connectionPosition = SCNVector3(-x, y, z)
        wheel2.connectionPosition = SCNVector3(x, y, z)
        wheel3.connectionPosition = SCNVector3(-x, y, -z)
        wheel4.connectionPosition = SCNVector3(x, y, -z)
        
        wheel1.suspensionStiffness = CGFloat(20)
        wheel2.suspensionStiffness = CGFloat(20)
        wheel3.suspensionStiffness = CGFloat(20)
        wheel4.suspensionStiffness = CGFloat(20)
                
        let suspensionRestLength = 0.15
        wheel1.suspensionRestLength = suspensionRestLength
        wheel2.suspensionRestLength = suspensionRestLength
        wheel3.suspensionRestLength = suspensionRestLength
        wheel4.suspensionRestLength = suspensionRestLength
        
        chassisNode.addChildNode(wheel1Node)
        chassisNode.addChildNode(wheel2Node)
        chassisNode.addChildNode(wheel3Node)
        chassisNode.addChildNode(wheel4Node)
        
        let vehicle = SCNPhysicsVehicle(chassisBody: body, wheels: [wheel1, wheel2, wheel3, wheel4])
        
        chassisNode.position = position
        chassisNode.position.y += 0.3
        
        sceneView.scene.rootNode.addChildNode(chassisNode)
        self.sceneView.scene.physicsWorld.addBehavior(vehicle)
        self.entities.append(chassisNode)
        
        let vehicleComponent = VehiclePhysicsComponent(vehicle: vehicle, wheels: [wheel1, wheel2, wheel3, wheel4])
        let positionComponent = PositionComponent(position: position)
        
        chassisNode.addComponent(vehicleComponent)
        chassisNode.addComponent(positionComponent)
        print(chassisNode.getId(), "esse é o uuid do carro gerado")
        isVehicleAdded = true
    }
   
    
    func setupControls() {
        let leftButton = UIButton(frame: CGRect(x: 20, y: self.view.frame.height - 120, width: 100, height: 50))
        leftButton.backgroundColor = .green
        leftButton.setTitle("👈🏽", for: .normal)
        leftButton.addTarget(self, action: #selector(turnLeft), for: .touchDown)
        leftButton.addTarget(self, action: #selector(resetOrientation), for: .touchUpInside)
        self.view.addSubview(leftButton)
        
        let rightButton = UIButton(frame: CGRect(x: 130, y: self.view.frame.height - 120, width: 100, height: 50))
        rightButton.backgroundColor = .yellow
        rightButton.setTitle("👉🏽", for: .normal)
        rightButton.addTarget(self, action: #selector(turnRight), for: .touchDown)
        rightButton.addTarget(self, action: #selector(resetOrientation), for: .touchUpInside)
        self.view.addSubview(rightButton)
        
        let forwardButton = UIButton(frame: CGRect(x: self.view.frame.width - 120, y: self.view.frame.height - 180, width: 100, height: 50))
        forwardButton.backgroundColor = .blue
        forwardButton.setTitle("👆🏽", for: .normal)
        forwardButton.addTarget(self, action: #selector(moveForward), for: .touchDown)
        forwardButton.addTarget(self, action: #selector(resetSpeed), for: .touchUpInside)
        self.view.addSubview(forwardButton)
        
        let backwardButton = UIButton(frame: CGRect(x: self.view.frame.width - 120, y: self.view.frame.height - 120, width: 100, height: 50))
        backwardButton.backgroundColor = .red
        backwardButton.setTitle("👇🏼", for: .normal)
        backwardButton.addTarget(self, action: #selector(moveBackward), for: .touchDown)
        backwardButton.addTarget(self, action: #selector(resetSpeed), for: .touchUpInside)
        self.view.addSubview(backwardButton)
    }
    
    @objc func moveForward() {
        movementSystem.engineForce = 1
    }
    
    @objc func moveBackward() {
        movementSystem.engineForce = -1
    }
    
    @objc func turnRight() {
        movementSystem.steeringAngle = -0.5
    }
    
    @objc func turnLeft() {
        movementSystem.steeringAngle = 0.5
    }
    
    @objc func resetOrientation() {
        movementSystem.steeringAngle = 0.0
    }
    
    @objc func resetSpeed() {
        movementSystem.engineForce = 0
    }
    
    // Atualizar a lógica de jogo a cada frame
    func update(deltaTime: TimeInterval) {
        

        
        movementSystem.update(deltaTime: deltaTime, entities: entities)
        renderSystem.update(deltaTime: deltaTime, entities: entities)
    }
    
    func changed() {
        self.trafficLightComponent.removeFromSuperview()
    }
    
    // Chamar a função de atualização de jogo no loop principal
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let displayLink = CADisplayLink(target: self, selector: #selector(gameLoop))
        displayLink.add(to: .current, forMode: .default)
    }
    
    @objc func gameLoop(displayLink: CADisplayLink) {
        let deltaTime = displayLink.duration
        update(deltaTime: deltaTime)
    }
}


enum Lado{
    case L
    case R
}

extension UIColor {
    static let transparentLightBlue = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
}
