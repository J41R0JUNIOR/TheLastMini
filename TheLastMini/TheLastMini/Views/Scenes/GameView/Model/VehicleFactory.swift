//
//  VehicleFactory.swift
//  TheLastMini
//
//  Created by Jairo Júnior on 13/08/24.
//

import Foundation
import SceneKit


struct VehicleFactory{
    
    private let vehicleModel: VehicleModel
    var vehicle = SCNPhysicsVehicle()

    init(vehicleModel: VehicleModel) {
        self.vehicleModel = vehicleModel
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
    
    mutating func createChassi() -> SCNNode{
        let chassisNode = createChassis()
        let boxGeometry = SCNBox(width: 0.06, height: 0.03, length: 0.12, chamferRadius: 0.0)
        let boxShape = SCNPhysicsShape(geometry: boxGeometry, options: nil)
        let body = SCNPhysicsBody(type: .dynamic, shape: boxShape)
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
        
        
        wheel1.connectionPosition = SCNVector3(-vehicleModel.xWheel, vehicleModel.yWheel, vehicleModel.zfWheel)
        wheel2.connectionPosition = SCNVector3(vehicleModel.xWheel, vehicleModel.yWheel, vehicleModel.zfWheel)
        wheel3.connectionPosition = SCNVector3(-vehicleModel.xWheel, vehicleModel.yWheel, -vehicleModel.zbWheel)
        wheel4.connectionPosition = SCNVector3(vehicleModel.xWheel, vehicleModel.yWheel, -vehicleModel.zbWheel)
        
        wheel1.suspensionStiffness = CGFloat(vehicleModel.suspensionStiffness)
        wheel2.suspensionStiffness = CGFloat(vehicleModel.suspensionStiffness)
        wheel3.suspensionStiffness = CGFloat(vehicleModel.suspensionStiffness)
        wheel4.suspensionStiffness = CGFloat(vehicleModel.suspensionStiffness)
        

        wheel1.suspensionRestLength = vehicleModel.suspensionRestLength
        wheel2.suspensionRestLength = vehicleModel.suspensionRestLength
        wheel3.suspensionRestLength = vehicleModel.suspensionRestLength
        wheel4.suspensionRestLength = vehicleModel.suspensionRestLength
        
        chassisNode.addChildNode(wheel1Node)
        chassisNode.addChildNode(wheel2Node)
        chassisNode.addChildNode(wheel3Node)
        chassisNode.addChildNode(wheel4Node)
        
        
        if let vehiclePhysicsBody = chassisNode.physicsBody {
            vehicle = SCNPhysicsVehicle(chassisBody: vehiclePhysicsBody, wheels: [wheel1, wheel2, wheel3, wheel4])
        }
        
        
        return chassisNode
    }
}
