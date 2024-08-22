import Foundation
import SceneKit

class VehicleFactory {
    
    private let vehicleModel: VehicleModel
    private var vehicle = SCNPhysicsVehicle()
    private var chassisNode = SCNNode()
    
    private var wheels: [SCNPhysicsVehicleWheel] = []
    
    init(vehicleModel: VehicleModel) {
        self.vehicleModel = vehicleModel
        createChassis()
        createWheels()
        setupVehicle()
    }
    
    func createWheel(lado: Lado) -> SCNNode {
        let wheel = lado == .L ? vehicleModel.lWheelName : vehicleModel.rWheelName
        guard let wheelNode = SCNScene(named: wheel)?.rootNode else {
            fatalError("Could not load wheel asset")
        }
        return wheelNode.clone()
    }
    
    func createChassis() {
        guard let chassis = SCNScene(named: vehicleModel.chassisName),
              let node = chassis.rootNode.childNodes.first else {
            fatalError("Could not load chassis asset")
        }
        
        let boxGeometry = SCNBox(width: 0.06, height: 0.03, length: 0.12, chamferRadius: 0.0)
        let boxShape = SCNPhysicsShape(geometry: boxGeometry, options: nil)
        let body = SCNPhysicsBody(type: .dynamic, shape: boxShape)
        body.mass = 1.0
        
        node.name = "CarNode"
        node.physicsBody = body
        node.physicsBody?.categoryBitMask = BodyType.car.rawValue
        node.physicsBody?.contactTestBitMask = BodyType.check.rawValue | BodyType.ground.rawValue | BodyType.wall.rawValue | BodyType.finish.rawValue | BodyType.poca.rawValue
        
        self.chassisNode = node
    }
    
    func createWheels() {
        let wheelPositions = [
            SCNVector3(-vehicleModel.xWheel, vehicleModel.yWheel, vehicleModel.zfWheel),
            SCNVector3(vehicleModel.xWheel, vehicleModel.yWheel, vehicleModel.zfWheel),
            SCNVector3(-vehicleModel.xWheel, vehicleModel.yWheel, -vehicleModel.zbWheel),
            SCNVector3(vehicleModel.xWheel, vehicleModel.yWheel, -vehicleModel.zbWheel)
        ]
        
        let wheelSides: [Lado] = [.R, .L, .R, .L]
        
        for (index, position) in wheelPositions.enumerated() {
            let wheelNode = createWheel(lado: wheelSides[index])
            let wheel = SCNPhysicsVehicleWheel(node: wheelNode)
            
            wheel.connectionPosition = position
            wheel.suspensionStiffness = CGFloat(vehicleModel.suspensionStiffness)
            wheel.suspensionRestLength = vehicleModel.suspensionRestLength
            
            wheels.append(wheel)
            chassisNode.addChildNode(wheelNode)
        }
    }
    
    func setupVehicle() {
        guard let vehiclePhysicsBody = chassisNode.physicsBody else {
            fatalError("Chassis node does not have a physics body")
        }
        vehicle = SCNPhysicsVehicle(chassisBody: vehiclePhysicsBody, wheels: wheels)
    }
    
    func getVehicle() -> SCNPhysicsVehicle {
        return vehicle
    }
    func getChassisNOde() -> SCNNode {
        return chassisNode
    }
}
