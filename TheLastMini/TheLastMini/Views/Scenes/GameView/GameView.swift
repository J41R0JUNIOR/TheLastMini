import Foundation
import ARKit
import FocusNode
import SmartHitTest

class GameView: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate, ARSessionDelegate, TrafficLightDelegate {
    internal var sceneView: ARSCNView = ARSCNView(frame: .zero)
    internal var isVehicleAdded = false
    internal let vehicleModel: VehicleModel
    internal var shouldHandleResetRequest = false
    internal var soundManager: SoundManager = SoundManager.shared
    internal var checkpointsNode: [SCNNode?] = []
    private var finishNode: SCNNode?
    private var entities: [Entity] = []
    private let movementSystem = MovementSystem()
    private let renderSystem = RenderSystem()
    internal let focusNode = FocusNode()
    internal var tapGesture: UITapGestureRecognizer?
    private var idleAudioPlayer: SCNAudioPlayer?
    private var accelerateAudioPlayer: SCNAudioPlayer?
    private var startAudioPlayer: SCNAudioPlayer?
        
    ///View de animacao de scan
    internal lazy var coachingOverlay: ARCoachingOverlayView = {
        let arView = ARCoachingOverlayView()
        arView.translatesAutoresizingMaskIntoConstraints = false
        return arView
    }()
    
    internal lazy var replaceAndPlay: ReplaceAndPlayComponent = {
        let view = ReplaceAndPlayComponent()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    internal lazy var lapAndTimer: LapAndTimerView = {
        let view = LapAndTimerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    internal lazy var endView: EndRaceView = {
        let view = EndRaceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    internal var trafficLightComponent: TrafficLightComponent = {
        let view = TrafficLightComponent(frame: .init(origin: .zero, size: .init(width: 200, height: 100)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    internal lazy var carControlViewComponent: CarControlComponent = {
        return CarControlComponent(movementSystem: self.movementSystem, frame: self.view.frame)
    }()
    
    internal lazy var resumoViewComponent: ResultsViewController = {
        return ResultsViewController(map: "Mount Fuji Track")
    }()
    
    
    init(vehicleModel: VehicleModel){
        self.vehicleModel = vehicleModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupScene()
        self.setupViewCode()
        self.setupAudio()
    }
    
    deinit{
        self.shouldHandleResetRequest = false
    }
    
    private func setupAudio(){
        self.idleAudioPlayer = SCNAudioPlayer(source: soundManager.loadCarAudio(.idlCar, false))
        self.startAudioPlayer = SCNAudioPlayer(source: soundManager.loadCarAudio(.startCar, false))
        self.accelerateAudioPlayer = SCNAudioPlayer(source: soundManager.loadCarAudio(.accelerateCar1, true))
    }
    
    private func playSong(_ audioPlayer: SCNAudioPlayer){
        guard let carNode = sceneView.scene.rootNode.childNode(withName: "CarNode", recursively: true) else { return }
        carNode.removeAllAudioPlayers()
        carNode.addAudioPlayer(audioPlayer)
    }
    
    func stopAllSounds() {
        guard let carNode = sceneView.scene.rootNode.childNode(withName: "CarNode", recursively: true) else { return }
        carNode.removeAllAudioPlayers()
    }
    
    internal func configureFocusNode(){
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
        floorNode.opacity = 0
        floorNode.position.y -= 0.1
        self.addNodeToScene(node: floorNode)
        
//        let speedwayNode = createSpeedway(setPhysics: true)
//        speedwayNode.position = position
//        speedwayNode.position.y -= 0.1
//        self.addNodeToScene(node: speedwayNode)
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
        coachingOverlay.goal = .anyPlane

        sceneView.session.run(configuration)
    }
    
    func createWheel(lado: Lado) -> SCNNode {
        let wheel = lado == .L ? vehicleModel.lWheelName : vehicleModel.rWheelName
        guard let wheelNode = SCNScene(named: wheel)?.rootNode else {
            fatalError("Could not load wheel asset")
        }
        return wheelNode.clone()
    }
    
    func createChassis() -> SCNNode {
        guard let chassis = SCNScene(named: vehicleModel.chassisName),
              let chassisNode = chassis.rootNode.childNodes.first else {
            fatalError("Could not load chassis asset")
        }
        
        let boxGeometry = SCNBox(width: 0.06, height: 0.03, length: 0.12, chamferRadius: 0.0)
        let boxShape = SCNPhysicsShape(geometry: boxGeometry, options: nil)
        let body = SCNPhysicsBody(type: .dynamic, shape: boxShape)
        body.mass = 1.0
        
        chassisNode.name = "CarNode"
        chassisNode.physicsBody = body
        chassisNode.physicsBody?.categoryBitMask = BodyType.car.rawValue
        chassisNode.physicsBody?.contactTestBitMask = BodyType.check.rawValue | BodyType.ground.rawValue | BodyType.wall.rawValue | BodyType.finish.rawValue
        
        return chassisNode
    }
    
    func createSpeedway(setPhysics: Bool) ->SCNNode{
        guard let pista = SCNScene(named: "pistaWall2.usdz"),
              let pistaNode = pista.rootNode.childNodes.first else {
            fatalError("Could not load wheel asset")
        }
        
//        let body = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: pistaNode, options: [SCNPhysicsShape.Option.keepAsCompound: true]))
//        pistaNode.physicsBody = body
        
        if setPhysics {
            
            for i in 1...12 {
                guard let checkNode = pistaNode.childNode(withName: "CP\(i)", recursively: true) else { fatalError("Checkpoint\(i) not found") }
                checkNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
                checkNode.physicsBody?.categoryBitMask = BodyType.check.rawValue
                checkNode.name = "\(i)"
                checkpointsNode.append(checkNode)
            }
            
            for i in 1...7 {
                guard let wallNode = pistaNode.childNode(withName: "InvWall\(i)", recursively: true) else { fatalError("InvWall\(i) not found") }
                wallNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: wallNode, options: nil))
                wallNode.physicsBody?.categoryBitMask = BodyType.wall.rawValue
            }
            
//            guard let finishNode = pistaNode.childNode(withName: "CP1", recursively: true) else { fatalError("Finish Node not found") }
//            finishNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
//            finishNode.physicsBody?.categoryBitMask = BodyType.finish.rawValue
//            self.finishNode = finishNode
            
//            guard let groundNode = pistaNode.childNode(withName: "Pista", recursively: true) else { fatalError("Ground Node not found") }
//            groundNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: groundNode, options: nil))
//            groundNode.physicsBody?.categoryBitMask = BodyType.ground.rawValue
            
//            guard let externalWall = pistaNode.childNode(withName: "Paredes_externas", recursively: true) else { fatalError("Paredes externas Node not found") }
//            externalWall.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: externalWall, options: nil))
//            externalWall.physicsBody?.categoryBitMask = BodyType.wall.rawValue
            
//            guard let internalWall = pistaNode.childNode(withName: "Paredes_internas", recursively: true) else { fatalError("Paredes internas Node not found") }
//            internalWall.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: internalWall, options: nil))
//            internalWall.physicsBody?.categoryBitMask = BodyType.wall.rawValue
//            centerWall.isHidden = true
            
        }
        
//        finishNode = pistaNode.childNode(withName: "Finish", recursively: true)
        pistaNode.name = "pistaNode"
//        speedwayNode = pistaNode
        return pistaNode
    }
    
    func setupVehicle(at position: SCNVector3) {
        let chassisNode = createChassis()
//        let boxGeometry = SCNBox(width: 0.09, height: 0.04, length: 0.12, chamferRadius: 0.0)
           
        
        let wheel1Node = createWheel(lado: .R)
        let wheel2Node = createWheel(lado: .L)
        let wheel3Node = createWheel(lado: .R)
        let wheel4Node = createWheel(lado: .L)
        
        let wheel1 = SCNPhysicsVehicleWheel(node: wheel1Node)
        let wheel2 = SCNPhysicsVehicleWheel(node: wheel2Node)
        let wheel3 = SCNPhysicsVehicleWheel(node: wheel3Node)
        let wheel4 = SCNPhysicsVehicleWheel(node: wheel4Node)
        
        let x: Double = vehicleModel.xWheel
        let y: Double = vehicleModel.yWheel
        let zf: Double = vehicleModel.zfWheel
        let zb: Double = vehicleModel.zbWheel
        
        wheel1.connectionPosition = SCNVector3(-x, y, zf)
        wheel2.connectionPosition = SCNVector3(x, y, zf)
        wheel3.connectionPosition = SCNVector3(-x, y, -zb)
        wheel4.connectionPosition = SCNVector3(x, y, -zb)
        
        wheel1.suspensionStiffness = CGFloat(vehicleModel.suspensionStiffness)
        wheel2.suspensionStiffness = CGFloat(vehicleModel.suspensionStiffness)
        wheel3.suspensionStiffness = CGFloat(vehicleModel.suspensionStiffness)
        wheel4.suspensionStiffness = CGFloat(vehicleModel.suspensionStiffness)
        
//        let suspensionRestLength = 0.04
//        let suspensionRestLength = 0.15

        wheel1.suspensionRestLength = vehicleModel.suspensionRestLength
        wheel2.suspensionRestLength = vehicleModel.suspensionRestLength
        wheel3.suspensionRestLength = vehicleModel.suspensionRestLength
        wheel4.suspensionRestLength = vehicleModel.suspensionRestLength
        
        chassisNode.addChildNode(wheel1Node)
        chassisNode.addChildNode(wheel2Node)
        chassisNode.addChildNode(wheel3Node)
        chassisNode.addChildNode(wheel4Node)
        
        var vehicle = SCNPhysicsVehicle()
        
        if let vehiclePhysicsBody = chassisNode.physicsBody {
            vehicle = SCNPhysicsVehicle(chassisBody: vehiclePhysicsBody, wheels: [wheel1, wheel2, wheel3, wheel4])
        }
        
        chassisNode.position = position
//        chassisNode.position.y += 0.1  
//        chassisNode.position.x -= 1
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
        carControlViewComponent.isHidden = false
    }
    
    func update(deltaTime: TimeInterval) {
        movementSystem.update(deltaTime: deltaTime, entities: entities)
        renderSystem.update(deltaTime: deltaTime, entities: entities)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let displayLink = CADisplayLink(target: self, selector: #selector(gameLoop))
        displayLink.add(to: .current, forMode: .default)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.playTimer()
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
                if lapAndTimer.currentLap != 1 {
                    DispatchQueue.main.async {
                        self.lapAndTimer.addLap()
                    }
                }else {
                    lapAndTimer.pauseTimer()
                    Task{
//                        await self.soundManager.playSong(fileName: .voiceCong)
                        await self.soundManager.playSong(fileName: .soundCong)
                    }
                    DispatchQueue.main.async {
                        self.endView.isHidden = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            self.resumoViewComponent.laps = self.lapAndTimer.lapsTime
                            self.resumoViewComponent.saveTimeRecord()
                            self.resumoViewComponent.setupTrackInfoView()
                            self.present(self.resumoViewComponent, animated: false)
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
        self.playSong(self.idleAudioPlayer!)
    }
    
    private func playTimer(){
        Timer.scheduledTimer(withTimeInterval: 6, repeats: true) { time in
            //label talvez
            //call function
            print("✅✅✅⬇️🚨🚨🚨🚨🚨🚨🚨🚨")
//            if !shouldHandleResetRequest{
//
//            }
        }
    }
}

