//
//  File.swift
//  TheLastMini
//
//  Created by Jairo Júnior on 31/07/24.
//

import Foundation
import RealityKit

class RenderSystem {
    func update(deltaTime: TimeInterval, entities: [Entity]) {
        for entity in entities {
            guard let position = entity.getComponent(ofType: PositionComponent.self) else { continue }
            
            // Atualizar a posição do node
//            entity.position = position.position
//            print(position)
//            print("entity.position", entity.position)
          
        }
    }
}

class MovementSystem {
    func changed() {
        canMove = true
    }
    
 
    
    var steeringAngle: CGFloat = 0.0
    var engineForce: CGFloat = 0.0
    var canMove: Bool = false
    
    func update(deltaTime: TimeInterval, entities: [Entity]) {
        for entity in entities {
            guard let vehiclePhysics = entity.getComponent(ofType: VehiclePhysicsComponent.self) else { continue }
            
            vehiclePhysics.vehicle.setSteeringAngle(steeringAngle, forWheelAt: 0)
            vehiclePhysics.vehicle.setSteeringAngle(steeringAngle, forWheelAt: 1)
            if canMove {
                vehiclePhysics.vehicle.applyEngineForce(engineForce, forWheelAt: 2)
                vehiclePhysics.vehicle.applyEngineForce(engineForce, forWheelAt: 3)
            }
        }
    }
}




