import Foundation
import ARKit
import FocusNode
import SmartHitTest

class GameView: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate, ARSessionDelegate, TrafficLightDelegate {
    var sceneView: ARSCNView = ARSCNView(frame: .zero)
    var isVehicleAdded = false

    var checkpointsNode: [SCNNode?] = []
    var finishNode: SCNNode?
    
    var entities: [Entity] = []
    let movementSystem = MovementSystem()
    let renderSystem = RenderSystem()
    let focusNode = FocusNode()
    
    var tapGesture: UITapGestureRecognizer?
    
    private var speedwayNode: SCNNode?
    
    ///View de animacao de scan
    private lazy var coachingOverlay: ARCoachingOverlayView = {
        let arView = ARCoachingOverlayView()
        arView.translatesAutoresizingMaskIntoConstraints = false
        return arView
    }()
    
    private lazy var replaceAndPlay: ReplaceAndPlayComponent = {
        let view = ReplaceAndPlayComponent()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var lapAndTimer: LapAndTimerView = {
        let view = LapAndTimerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var endView: EndRaceView = {
        let view = EndRaceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var trafficLightComponent: TrafficLightComponent = {
        let view = TrafficLightComponent(frame: .init(origin: .zero, size: .init(width: 200, height: 100)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var carControlComponent = CarControlComponent(movementSystem: self.movementSystem, frame: self.view.frame)
    
    private lazy var resumoView: ResultsViewController = {
        return ResultsViewController(map: "Mount Fuji Track")
    }()
      
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupScene()
        self.setupViewCode()

    }
    
    
    private func configureFocusNode(){
        focusNode.childNodes.forEach { $0.removeFromParentNode() }


        let customNode = createSpeedway(setPhysics: false)
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
        
        let speedwayNode = createSpeedway(setPhysics: true)
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
    
    func createSpeedway(setPhysics: Bool) ->SCNNode{
        guard let pista = SCNScene(named: "TestPistaWallMaior.usdz"),
              let pistaNode = pista.rootNode.childNodes.first else {
            fatalError("Could not load wheel asset")
        }
        
//        let body = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: pistaNode, options: [SCNPhysicsShape.Option.keepAsCompound: true]))
//        pistaNode.physicsBody = body
        
        if setPhysics {
            
            for i in 1...6 {
                guard let checkNode = pistaNode.childNode(withName: "Checkpoint\(i)", recursively: true) else { fatalError("Checkpoint\(i) not found") }
                checkNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
                checkNode.physicsBody?.categoryBitMask = BodyType.check.rawValue
                checkNode.name = "\(i)"
                checkpointsNode.append(checkNode)
            }
            
            for i in 1...4 {
                guard let wallNode = pistaNode.childNode(withName: "InvWall\(i)", recursively: true) else { fatalError("InvWall\(i) not found") }
                wallNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: wallNode))
                wallNode.physicsBody?.categoryBitMask = BodyType.wall.rawValue
                //            checkNode.name = "wall\(i)"
            }
            
            guard let finishNode = pistaNode.childNode(withName: "Finish", recursively: true) else { fatalError("Finish Node not found") }
            finishNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
            finishNode.physicsBody?.categoryBitMask = BodyType.finish.rawValue
            self.finishNode = finishNode
            
            guard let groundNode = pistaNode.childNode(withName: "Ground", recursively: true) else { fatalError("Ground Node not found") }
            groundNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
            groundNode.physicsBody?.categoryBitMask = BodyType.ground.rawValue
            
            guard let centerWall = pistaNode.childNode(withName: "CenterWall", recursively: true) else { fatalError("CenterWall Node not found") }
            centerWall.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
            centerWall.physicsBody?.categoryBitMask = BodyType.wall.rawValue
            
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
        chassisNode.physicsBody?.categoryBitMask = BodyType.car.rawValue
        chassisNode.physicsBody?.contactTestBitMask = BodyType.check.rawValue | BodyType.ground.rawValue | BodyType.wall.rawValue | BodyType.finish.rawValue
        
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
    
    func setupControls(){
        self.view.addSubview(carControlComponent)

        // Configurar restrições para o carControlComponent
        NSLayoutConstraint.activate([
            carControlComponent.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carControlComponent.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carControlComponent.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            carControlComponent.heightAnchor.constraint(equalToConstant: 200)
        ])
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
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        
        // Verificar qual nó é o carrinho e qual é o checkpoint
        if (nodeA.physicsBody?.categoryBitMask == BodyType.car.rawValue && nodeB.physicsBody?.categoryBitMask == BodyType.check.rawValue) ||
           (nodeA.physicsBody?.categoryBitMask == BodyType.check.rawValue && nodeB.physicsBody?.categoryBitMask == BodyType.car.rawValue) {
            let checkpointNode = nodeA.physicsBody?.categoryBitMask == BodyType.check.rawValue ? nodeA : nodeB
//            print("Carrinho passou pelo checkpoint: \(checkpointNode.name ?? "nil")")
            
            if verifyIsCheckNodes(nodeName: checkpointNode.name ?? "nil"){
                checkpointNode.isCheck = true
            }
        }
        
        if (nodeA.physicsBody?.categoryBitMask == BodyType.car.rawValue && nodeB.physicsBody?.categoryBitMask == BodyType.finish.rawValue) ||
            (nodeA.physicsBody?.categoryBitMask == BodyType.finish.rawValue && nodeB.physicsBody?.categoryBitMask == BodyType.car.rawValue) {
//            print("Carrinho passou pelo Finish")
            for node in checkpointsNode {
//                print("Checkpoint \(String(describing: node?.name)): \(String(describing: node?.isCheck))")
            }
            
            if checkpointsNode.allSatisfy({ $0!.isCheck }) {
//                print("Todos os checkpoints estão ativados")
                lapAndTimer.saveLapTime()
                for node in checkpointsNode {
                    node?.isCheck = false
                }
                if lapAndTimer.currentLap != 2 {
                    DispatchQueue.main.async {
                        self.lapAndTimer.addLap()
                    }
                }else {
                    lapAndTimer.pauseTimer()
                    DispatchQueue.main.async {
                        self.endView.isHidden = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            self.resumoView.laps = self.lapAndTimer.lapsTime
                            self.resumoView.saveTimeRecord()
                            self.present(self.resumoView, animated: false)
                        }
                    }
                }
            }
            
        }
        
    }
    
    private func verifyIsCheckNodes(nodeName: String)-> Bool {
        for arrayNode in checkpointsNode {
            if arrayNode?.name == nodeName {
                if !arrayNode!.isCheck {
                    return true
                } else {
                    break
                }
            }
            if !arrayNode!.isCheck {
                continue
            }
        }
        return false
    }
    
    
    
    func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        // Registrar algo quando termina o contato aqui
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        self.focusNode.updateFocusNode()
    }
    
    func changed() {
        self.trafficLightComponent.removeFromSuperview()
        movementSystem.changed()
        lapAndTimer.isHidden = false
        lapAndTimer.playTimer()
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
        self.view.addListSubviews(sceneView, replaceAndPlay, coachingOverlay, trafficLightComponent, lapAndTimer, endView)
        
        self.replaceAndPlay.delegate = self
        self.trafficLightComponent.delegate = self
        focusNode.viewDelegate = sceneView
        self.focusNode.name = "focusNode"
        self.resumoView.delegate = self

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
            
            lapAndTimer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            lapAndTimer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            lapAndTimer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            lapAndTimer.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            lapAndTimer.heightAnchor.constraint(equalToConstant: 50),
            
            endView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            endView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    func setupStyle() {
        
    }
}

extension GameView: ResultsViewControllerDelegate {
    func backTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}


#Preview{
    GameView()
}
