//
//  System.swift
//  TheLastMini
//
//  Created by Jairo Júnior on 29/07/24.
//

import Foundation
import SceneKit

protocol System {
    func update(deltaTime: TimeInterval, entities: [Entity])
}

class MovementSystem: System {
    var positionComponents: [UUID: PositionComponent] = [:]
    var velocityComponents: [UUID: VelocityComponent] = [:]
    
    func update(deltaTime: TimeInterval, entities: [Entity]) {
        for entity in entities {
            guard let position = positionComponents[entity.id], let velocity = velocityComponents[entity.id] else {
                continue
            }
            
            // Atualiza a posição com base na velocidade e tempo decorrido
            positionComponents[entity.id]?.x += Double(velocity.x) * Double(deltaTime)
            positionComponents[entity.id]?.y += Double(velocity.y) * Double(deltaTime)
            positionComponents[entity.id]?.z += velocity.z * Double(deltaTime)
        }
    }
}


class RenderSystem: System {
    var positionComponents: [UUID: PositionComponent] = [:]
    var renderComponents: [UUID: RenderComponent] = [:]
    
    func update(deltaTime: TimeInterval, entities: [Entity]) {
        for entity in entities {
            guard let position = positionComponents[entity.id], let render = renderComponents[entity.id] else {
                continue
            }
            
            // Atualiza a posição do nó com base no componente de posição
            render.node.position = SCNVector3(position.x, position.y, position.z)
        }
    }
}

