import Foundation
import ARKit
import FocusNode
import SmartHitTest

class GameView: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate, ARSessionDelegate, TrafficLightDelegate {
    internal var sceneView: ARSCNView = ARSCNView(frame: .zero)
    internal var isVehicleAdded = false
    internal var chassi: VehicleFactory
    internal let roadModel: RoadModel
    internal var shouldHandleResetRequest = false
    internal var isInicialazeCoach: Bool = false
    internal var soundManager: SoundManager = SoundManager.shared
    internal var checkpointsNode: [SCNNode?] = []
    internal var pocasNode: [SCNNode?] = []
    private var finishNode: SCNNode?
    private var entities: [Entity] = []
    private let movementSystem = MovementSystem()
    private let renderSystem = RenderSystem()
    internal let focusNode = FocusNode()
    internal var tapGesture: UITapGestureRecognizer?
    private var idleAudioPlayer: SCNAudioPlayer?
    private var accelerateAudioPlayer: SCNAudioPlayer?
    private var startAudioPlayer: SCNAudioPlayer?
    private let userDefualt: UserDefaults = UserDefaults.standard
        
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
        let view = CarControlComponent(movementSystem: self.movementSystem)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    internal lazy var resumoView: ResultsViewController = {
        return ResultsViewController(map: "Dragon Road")
    }()
    
    internal lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Position the track and click on the screen to position"
        label.font = UIFont(name: FontsCuston.fontBoldItalick.rawValue, size: 22)
        label.backgroundColor = .black.withAlphaComponent(0.5)
        label.layer.cornerRadius = 3
        label.clipsToBounds = true
        label.textColor = .amarelo
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal lazy var labelValocity: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.font = UIFont(name: FontsCuston.fontBoldItalick.rawValue, size: 50)
        label.textColor = .white
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal lazy var imagePosa: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(resource: .posa)
        image.contentMode = .scaleAspectFill
        image.alpha = 0
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    init(chassisNode: VehicleFactory, roadModel: RoadModel){
        self.chassi = chassisNode
        self.roadModel = roadModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupScene()
        self.setupViewCode()
    }
    
    internal func configureFocusNode(){
        focusNode.childNodes.forEach { $0.removeFromParentNode() }
        
        let customNode = createSpeedway(setPhysics: false)
        if customNode.parent != nil {
            focusNode.addChildNode(customNode)
        }
        
        customNode.scale = SCNVector3(0.5, 0.5, 0.5) 
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
        self.label.isHidden = true

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
//        floorNode.position.y -= 0.2
        floorNode.opacity = 0
        self.addNodeToScene(node: floorNode)
        
        let speedwayNode = createSpeedway(setPhysics: true)
        speedwayNode.position = position
//        speedwayNode.position.y -= 0.2
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
        sceneView.autoenablesDefaultLighting = true
//        sceneView.debugOptions = .showPhysicsShapes
        
        sceneView.scene.physicsWorld.contactDelegate = self
        
        let configuration = ARWorldTrackingConfiguration()
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh){
            configuration.sceneReconstruction = .mesh
        }
        configuration.wantsHDREnvironmentTextures = true
        configuration.planeDetection = [.horizontal]
        
        coachingOverlay.session = sceneView.session
        coachingOverlay.delegate = self
        coachingOverlay.goal = .horizontalPlane
        
        sceneView.session.run(configuration)
    }
    
    func createSpeedway(setPhysics: Bool) ->SCNNode{
        guard let pista = SCNScene(named: "pistaandre.usdz"),
              let pistaNode = pista.rootNode.childNodes.first else {
            fatalError("Could not load wheel asset")
        }
        
//        guard let pistaFinal = pistaNode.childNode(withName: "pista_final_2", recursively: true) else { fatalError("pistaFinal not found")}
        
        pistaNode.scale = SCNVector3(x: 1.5, y: 1, z: 1.5)
        
//        print("NODES CHILDS: \(pistaFinal.childNodes)")
        
        for i in 1...9 {
            guard let checkNode = pistaNode.childNode(withName: "Check\(i)", recursively: true) else { fatalError("Checkpoint\(i) not found") }
            checkNode.opacity = 0
            if setPhysics {
                checkNode.position.y += 0.04
                checkNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
                checkNode.physicsBody?.categoryBitMask = BodyType.check.rawValue
                checkNode.name = "\(i)"
                checkpointsNode.append(checkNode)
            }
        }
        
        guard let checkNode = pistaNode.childNode(withName: "Finish", recursively: true) else { fatalError("Checkpoint10 not found") }
        checkNode.opacity = 0
        if setPhysics {
            checkNode.position.y += 0.04
            checkNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
            checkNode.physicsBody?.categoryBitMask = BodyType.check.rawValue
            checkNode.name = "10"
            checkpointsNode.append(checkNode)
        }
        
        for i in 1... {
            if (i >= 3 && i <= 9) || i == 23 {
                continue
            }
            guard let wallNode = pistaNode.childNode(withName: "InvWall1_\(i)", recursively: true) else {
                print("Não achou a Parede\(i)")
                break
            }
            wallNode.opacity = 0
            if setPhysics {
                wallNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
                wallNode.physicsBody?.categoryBitMask = BodyType.wall.rawValue
            }
        }
        
        for i in 1... {
            if i == 2 {
                continue
            }
            guard let pocaNode = pistaNode.childNode(withName: "Poca\(i)", recursively: true) else {
                print("Não achou a Poca\(i)")
                break
            }
            // DESCOMENTAR QUANDO TIVER A POÇA MODELADA
            pocaNode.geometry?.materials.first?.diffuse.contents = UIColor.black.withAlphaComponent(0.8)
            pocaNode.opacity = 0
            pocaNode.name = "Poca\(i)"
            if setPhysics {
                pocaNode.position.y += 0.04
                pocaNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
                pocaNode.physicsBody?.categoryBitMask = BodyType.poca.rawValue
            }
        }
        
        if setPhysics {
            guard let finishNode = pistaNode.childNode(withName: "Check10", recursively: true) else { fatalError("Finish Node not found") }
            finishNode.position.y += 0.04
            finishNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
            finishNode.physicsBody?.categoryBitMask = BodyType.finish.rawValue
            finishNode.opacity = 0
            self.finishNode = finishNode
            
            guard let pocaNode = pistaNode.childNode(withName: "Plane", recursively: true) else {
                fatalError("Não achou a Plane")
            }
            guard let poca001Node = pistaNode.childNode(withName: "Plane001", recursively: true) else {
                fatalError("Não achou a Plane")
            }
            guard let poca002Node = pistaNode.childNode(withName: "Plane002", recursively: true) else {
                fatalError("Não achou a Plane")
            }
            pocasNode.append(pocaNode)
            pocasNode.append(poca001Node)
            pocasNode.append(poca002Node)
        }
        
        pistaNode.name = "pistaNode"
        return pistaNode
    }
    
    func setupVehicle(at position: SCNVector3) {
        let chassisNode = chassi.getChassisNOde()

        chassisNode.position = position
        chassisNode.position.y += 0.1
        chassisNode.position.z -= 0.1
        
        self.addNodeToScene(node: chassisNode)
        
        self.sceneView.scene.physicsWorld.addBehavior(self.chassi.getVehicle())
      
        self.entities.append(chassisNode)
        
        let vehicleComponent = VehiclePhysicsComponent(vehicle: self.chassi.getVehicle())
        let positionComponent = PositionComponent(position: position)
        chassisNode.addComponent(vehicleComponent)
        chassisNode.addComponent(positionComponent)
        
        isVehicleAdded = true
    }
    
    func setupControls(){
        carControlViewComponent.isHidden = false
    }
    
    func update(deltaTime: TimeInterval) {
        movementSystem.update(deltaTime: deltaTime, entities: entities)
        renderSystem.update(deltaTime: deltaTime, entities: entities)
        
        if let volume = movementSystem.vehiclePhysics?.vehicle.speedInKilometersPerHour, volume > 0{
            soundManager.changeVolume(volume)
            updateLabelVelocity(volume)
        }
    }
    
    func updateLabelVelocity(_ volume: CGFloat) {
            let newVelocity: CGFloat = volume * 20
            
            labelValocity.text = String(format: "%.00f\nVelocity", newVelocity)
            
            let colorPercentage = min(newVelocity / 100.0, 1.0)
            let color = UIColor(
                red: 1,
                green: 1 - colorPercentage,
                blue: 1 - colorPercentage,
                alpha: 1.0
            )
            
            UIView.animate(withDuration: 0.5) {
                self.labelValocity.textColor = color
            }
            
            UIView.animate(withDuration: 0.1, animations: {
                self.labelValocity.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    self.labelValocity.transform = .identity
                }
            }
        }
    
    // Chamar a função de atualização de jogo no loop principal
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let displayLink = CADisplayLink(target: self, selector: #selector(gameLoop))
        displayLink.add(to: .current, forMode: .default)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        self.playTimer()
    }
    
    @objc func gameLoop(displayLink: CADisplayLink) {
        let deltaTime = displayLink.duration
        update(deltaTime: deltaTime)
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        
        // CONTATO DO CARRO COM CHECKPOINT
        if (nodeA.physicsBody?.categoryBitMask == BodyType.car.rawValue && nodeB.physicsBody?.categoryBitMask == BodyType.check.rawValue) ||
            (nodeA.physicsBody?.categoryBitMask == BodyType.check.rawValue && nodeB.physicsBody?.categoryBitMask == BodyType.car.rawValue) {
            let checkpointNode = nodeA.physicsBody?.categoryBitMask == BodyType.check.rawValue ? nodeA : nodeB
            
            if verifyIsCheckNodes(nodeName: checkpointNode.name ?? "nil"){
                checkpointNode.isCheck = true
            }
        }
        
        // CONTA DO CARRO COM FINISH
        if (nodeA.physicsBody?.categoryBitMask == BodyType.car.rawValue && nodeB.physicsBody?.categoryBitMask == BodyType.finish.rawValue) ||
            (nodeA.physicsBody?.categoryBitMask == BodyType.finish.rawValue && nodeB.physicsBody?.categoryBitMask == BodyType.car.rawValue) {
            if checkpointsNode.allSatisfy({ $0!.isCheck }) {
                lapAndTimer.saveLapTime()
                for node in checkpointsNode {
                    node?.isCheck = false
                }
                if lapAndTimer.currentLap != 3 {
                    DispatchQueue.main.async {
                        self.lapAndTimer.addLap()
                    }
                }else {
                    lapAndTimer.pauseTimer()
                    Task{
                        await self.soundManager.playSong(fileName: .soundCong, .soundEffect)
                    }
                    DispatchQueue.main.async {
                        self.endView.isHidden = false
                        HapticsService.shared.addHapticFeedbackFromViewController(type: .success)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            self.resumoView.laps = self.lapAndTimer.lapsTime
                            self.resumoView.setupRank()
                            self.resumoView.saveTimeRecord()
                            self.present(self.resumoView, animated: false)
                        }
                    }
                }
            }
        }
        
        // CONTATO DO CARRO COM POCA
        if (nodeA.physicsBody?.categoryBitMask == BodyType.car.rawValue && nodeB.physicsBody?.categoryBitMask == BodyType.poca.rawValue) ||
            (nodeA.physicsBody?.categoryBitMask == BodyType.poca.rawValue && nodeB.physicsBody?.categoryBitMask == BodyType.car.rawValue) {
            let pocaNode = nodeA.physicsBody?.categoryBitMask == BodyType.poca.rawValue ? nodeA : nodeB
            
            if !pocaNode.isCheck {
                print("CARRINHO PASSOU PELA POÇA !!! 🕳️🕳️")
                pocaNode.isCheck = true
//                pocaNode.opacity = 0 // MUDAR A OPACIDADE DA POÇA MODELADA
                switch pocaNode.name {
                case "Poca1":
                    pocasNode[0]?.opacity = 0
                case "Poca3":
                    pocasNode[1]?.opacity = 0
                case "Poca4":
                    pocasNode[2]?.opacity = 0
                default:
                    break
                }
                DispatchQueue.main.async{
                    self.animateImage()
                }
            }
        }
    }
    
    private func animateImage() {
        UIView.animate(withDuration: 0.5, animations: {
            self.imagePosa.alpha = 1
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 0.5) {
                    self.imagePosa.alpha = 0
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
        labelValocity.isHidden = false
        lapAndTimer.playTimer()
         
        Task{
            await self.soundManager.playSong(fileName: .accelerateCar1, .soundEffect)
        }
    }
    
    private func playTimer(){
        Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { [self] time in
            if !isInicialazeCoach{
                setupDefualtConfig()
            }
        }
    }
    
    internal func setupDefualtConfig(){
        self.coachingOverlay.removeFromSuperview()
        configureFocusNode()
        setupTapGesture()
        self.label.isHidden = false
    }
}

//#Preview{
//    GameView()
//}

