import Foundation
import ARKit
import FocusNode
import SmartHitTest

class GameView: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate, ARSessionDelegate {
    var sceneView: ARSCNView = ARSCNView(frame: .zero)
    var isVehicleAdded = false

    var checkpointsNode: [SCNNode?] = []
    var finishNode: SCNNode?
    
    var entities: [Entity] = []
    let movementSystem = MovementSystem()
    let renderSystem = RenderSystem()
    let focusNode: FocusNode = FocusNode()
    
    var tapGesture: UITapGestureRecognizer?
    
    private var speedwayNode: SCNNode?
    
    ///View de animacao de scan
    private lazy var coachingOverlay: ARCoachingOverlayView = {
        let arView = ARCoachingOverlayView()
        arView.translatesAutoresizingMaskIntoConstraints = false
        return arView
    }()
    
    private lazy var replaceAndPlay: ReplaceAndPlayView = {
        let view = ReplaceAndPlayView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var trafficLightComponent = TrafficLightComponent(frame: .init(origin: .zero, size: .init(width: 200, height: 100)))
      
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupScene()
        self.setupViewCode()

    }
    
    
    private func configureFocusNode(){
        focusNode.childNodes.forEach { $0.removeFromParentNode() }


        let customNode = createSpeedway()
        print("Estou aqui: ", sceneView.scene.rootNode.childNodes.count, " [-] ", sceneView.scene.rootNode.childNodes)

        if customNode.parent != nil {
            focusNode.addChildNode(customNode)
        }
        
        customNode.scale = SCNVector3(0.1, 0.1, 0.1) //remover depois
        focusNode.isHidden = false
        

        if focusNode.parent != nil {
            self.addNodeToScene(node: self.focusNode)
        }
    }


    
    func setupTapGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture!)
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        focusNode.isHidden = true
        self.replaceAndPlay.isHidden = false
        self.tapGesture?.isEnabled = false

        setupFloor(at: focusNode.position)
    }
    
    func setupFloor(at position: SCNVector3){
        if isVehicleAdded {
            print("Ja removido!!!!!")
            return
        }
        
        isVehicleAdded = true
        
        let floor = SCNFloor()
        let floorNode = SCNNode(geometry: floor)
        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: floor, options: nil))
        floorNode.geometry?.materials.first?.diffuse.contents = UIColor.blue.withAlphaComponent(0.0)
        floorNode.position = position
        floorNode.position.y -= 0.2
        self.addNodeToScene(node: floorNode)
        
        let speedwayNode = createSpeedway()
        speedwayNode.position = position
        speedwayNode.position.y -= 0.1
        self.addNodeToScene(node: speedwayNode)
        setupVehicle(at: position)
    }
    
    func addNodeToScene(node: SCNNode){
        if node.parent != nil {
            node.removeFromParentNode()
        }
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func setupScene() {
        sceneView = ARSCNView(frame: self.view.frame)
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = [.showPhysicsShapes]
        sceneView.scene.physicsWorld.contactDelegate = self
                
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        
        coachingOverlay.session = sceneView.session
        coachingOverlay.delegate = self
        coachingOverlay.goal = .horizontalPlane

        sceneView.session.run(configuration)
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
    
    func createSpeedway() -> SCNNode{
//        if let existingSpeedway = speedwayNode {
//            return existingSpeedway.clone()
//        }
        
        guard let pista = SCNScene(named: "TestCompleteSpeedway.usdz"),
              let pistaNode = pista.rootNode.childNodes.first else {
            fatalError("Could not load wheel asset")
        }
        
        let body = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: pistaNode, options: [SCNPhysicsShape.Option.keepAsCompound: true]))
        pistaNode.physicsBody = body
        
        for i in 1...6 {
            let checkNode = pistaNode.childNode(withName: "Checkpoint\(i)", recursively: true)
            checkNode?.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: checkNode!))
            checkNode?.physicsBody?.categoryBitMask = 1 << 2 // 0010
            checkNode?.physicsBody?.contactTestBitMask = 1 << 1 // 0001
            checkNode?.name = "check\(i)"
            checkpointsNode.append(checkNode)
        }
        
        finishNode = pistaNode.childNode(withName: "Finish", recursively: true)
        pistaNode.name = "pistaNode"
//        speedwayNode = pistaNode
        return pistaNode
    }
    
    func setupVehicle(at position: SCNVector3) {
        let chassisNode = createChassis()
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: chassisNode))
        body.mass = 1.0
        chassisNode.physicsBody = body
        chassisNode.physicsBody?.categoryBitMask = 1 << 1  // 0001
        chassisNode.physicsBody?.contactTestBitMask = 1 << 2 // 0010
        
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
        self.addNodeToScene(node: chassisNode)
//        sceneView.scene.rootNode.addChildNode(chassisNode)

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
    
 
    
    // Chamar a função de atualização de jogo no loop principal
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let displayLink = CADisplayLink(target: self, selector: #selector(gameLoop))
        displayLink.add(to: .current, forMode: .default)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func gameLoop(displayLink: CADisplayLink) {
        let deltaTime = displayLink.duration
        update(deltaTime: deltaTime)
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        print("CONTACT DETECTED!")
        
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        
        // Verificar qual nó é o carrinho e qual é o checkpoint
        if (nodeA.physicsBody?.categoryBitMask == 1 << 2 && nodeB.physicsBody?.categoryBitMask == 1 << 1) ||
           (nodeA.physicsBody?.categoryBitMask == 1 << 1 && nodeB.physicsBody?.categoryBitMask == 1 << 2) {
            let checkpointNode = nodeA.physicsBody?.categoryBitMask == 1 << 2 ? nodeA : nodeB
            print("Carrinho passou pelo checkpoint: \(checkpointNode.name ?? "nil")")
        }
        
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        // Registrar algo quando termina o contato aqui
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        self.focusNode.updateFocusNode()
    }
}

extension GameView: TrafficLightDelegate{
    func changed() {
        self.trafficLightComponent.removeFromSuperview()
        movementSystem.changeCanMove()
//        setupControls()
    }
}


extension ARSCNView: ARSmartHitTest { }

//MARK: - Configuração de animação de scan
extension GameView: ARCoachingOverlayViewDelegate{
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print("Vai comecar ✅")
    }
    
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print("Sera que foi agora? 🐐")
        configureFocusNode()
        setupTapGesture()
    }
    
//    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
//        print("Pedi para refazer  🚨")
//    }
    
}

//MARK: Função de action replace and play button
extension GameView: NavigationDelegate{
    func navigationTo(_ tag: Int) {
        switch tag{
        case 10:
            print("Replace")
            if sceneView.scene.rootNode.childNodes.count > 0{
                sceneView.scene.rootNode.childNodes.forEach { node in
                    if node.name != "focusNode"{
                        node.removeFromParentNode()
                    }
                }
                self.isVehicleAdded = false
                self.replaceAndPlay.toggleVisibility()
                focusNode.isHidden = false
                self.tapGesture?.isEnabled = true
            }
        case 11:
            print("Play")
            setupControls()
            self.replaceAndPlay.toggleVisibility()
            self.trafficLightComponent.isHidden = false
            self.trafficLightComponent.startAnimation()
            
        default:
            print("ERROR in 'GameView->navigationTo': Tag invalida")
        }
    }
}

extension GameView: ViewCode{
    func addViews() {
        self.view.addListSubviews(sceneView, replaceAndPlay, coachingOverlay, trafficLightComponent)
        
        self.replaceAndPlay.delegate = self
        self.trafficLightComponent.delegate = self
        focusNode.viewDelegate = sceneView
        self.focusNode.name = "focusNode"

    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            coachingOverlay.topAnchor.constraint(equalTo: self.view.topAnchor),
            coachingOverlay.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            coachingOverlay.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            coachingOverlay.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            replaceAndPlay.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            replaceAndPlay.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            replaceAndPlay.heightAnchor.constraint(equalToConstant: 41),
            replaceAndPlay.widthAnchor.constraint(equalToConstant: 280),
            
            trafficLightComponent.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trafficLightComponent.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    func setupStyle() {
        
    }
}


#Preview{
    GameView()
}
