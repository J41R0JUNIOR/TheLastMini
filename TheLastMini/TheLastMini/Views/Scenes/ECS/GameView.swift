import Foundation
import ARKit

class GameView: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate, ARSessionDelegate {
    var sceneView: ARSCNView!
    var vehicleNode: SCNNode!
    var vehicle: SCNPhysicsVehicle!
    var isVehicleAdded = false

   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        setupControls()
        setupTapGesture()
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
        
        let position = SCNVector3(hitTestResult.worldTransform.columns.3.x,
                                  hitTestResult.worldTransform.columns.3.y + 0.2,
                                  hitTestResult.worldTransform.columns.3.z)
        
        print("Tapped position: \(position)")
        setupVehicle(at: position)
    }
    
    func setupFloor(){
        let floor = SCNFloor()
        let floorNode = SCNNode(geometry: floor)
        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: floor, options: nil))
        sceneView.scene.rootNode.addChildNode(floorNode)
        floorNode.geometry?.materials.first?.diffuse.contents = UIColor.blue.withAlphaComponent(0.7)
        floorNode.position = SCNVector3(x: 0, y: -1, z: -4)
    }


    func setupScene() {
        sceneView = ARSCNView(frame: self.view.frame)
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = [.showPhysicsShapes]
        self.view.addSubview(sceneView)
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        
        setupFloor()
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
        let y: Double = -0.031
        let z: Double = 0.25
        
        wheel1.connectionPosition = SCNVector3(-x, y, z)
        wheel2.connectionPosition = SCNVector3(x, y, z)
        wheel3.connectionPosition = SCNVector3(-x, y, -z)
        wheel4.connectionPosition = SCNVector3(x, y, -z)

        wheel1.suspensionStiffness = CGFloat(1)
        wheel2.suspensionStiffness = CGFloat(1)
        wheel3.suspensionStiffness = CGFloat(1)
        wheel4.suspensionStiffness = CGFloat(1)
        
        chassisNode.addChildNode(wheel1Node)
        chassisNode.addChildNode(wheel2Node)
        chassisNode.addChildNode(wheel3Node)
        chassisNode.addChildNode(wheel4Node)
        
        let vehicle = SCNPhysicsVehicle(chassisBody: body, wheels: [wheel1, wheel2, wheel3, wheel4])
        
        chassisNode.position = position
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


    func createPlane(anchor: ARPlaneAnchor) -> SCNNode {
        let planeNode = SCNNode()
        let geometry = SCNPlane(width: CGFloat(anchor.planeExtent.width), height: CGFloat(anchor.planeExtent.height))
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.transparentLightBlue
        geometry.materials = [material]
        
        planeNode.geometry = geometry
        planeNode.position = SCNVector3(anchor.center.x, anchor.center.y, anchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        let physicsShape = SCNPhysicsShape(geometry: geometry, options: nil)
        let physicsBody = SCNPhysicsBody(type: .static, shape: physicsShape)
        planeNode.physicsBody = physicsBody
        
        return planeNode
    }

    func setupControls() {
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
//
//    var lastUpdateTime: TimeInterval = 0
//
//    // MARK: - ARSCNViewDelegate
//    
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
//        
//        let plane = createPlane(anchor: planeAnchor)
//        
//        node.addChildNode(plane)
//    }
//
//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        guard let planeAnchor = anchor as? ARPlaneAnchor,
//              let planeNode = node.childNodes.first,
//              let plane = planeNode.geometry as? SCNPlane else { return }
//        
//        plane.width = CGFloat(planeAnchor.planeExtent.width)
//        plane.height = CGFloat(planeAnchor.planeExtent.height)
//        planeNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
//    }
//
//    func sessionWasInterrupted(_ session: ARSession) {
//        // Inform the user that the session has been interrupted, for example, by presenting an overlay.
//    }
//
//    func sessionInterruptionEnded(_ session: ARSession) {
//        resetTracking()
//    }
//
//    func session(_ session: ARSession, didFailWithError error: Error) {
//        guard error is ARError else { return }
//        
//        let errorWithInfo = error as NSError
//        let messages = [
//            errorWithInfo.localizedDescription,
//            errorWithInfo.localizedFailureReason,
//            errorWithInfo.localizedRecoverySuggestion
//        ]
//        
//        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
//        
//        DispatchQueue.main.async {
//            let alertController = UIAlertController(title: "The AR session failed.", message: errorMessage, preferredStyle: .alert)
//            let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
//                alertController.dismiss(animated: true, completion: nil)
//                self.resetTracking()
//            }
//            alertController.addAction(restartAction)
//            self.present(alertController, animated: true, completion: nil)
//        }
//    }
//
//    private func resetTracking() {
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.planeDetection = [.horizontal, .vertical]
//        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
//    }
}

enum Lado{
    case L
    case R
}

extension UIColor {
    static let transparentLightBlue = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
}
