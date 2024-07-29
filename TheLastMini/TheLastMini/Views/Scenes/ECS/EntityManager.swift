//
//  EntityManager.swift
//  TheLastMini
//
//  Created by Jairo Júnior on 29/07/24.
//

import Foundation

class EntityManager {
    var entities: [Entity] = []
    var positionComponents: [UUID: PositionComponent] = [:]
    var velocityComponents: [UUID: VelocityComponent] = [:]
    var renderComponents: [UUID: RenderComponent] = [:]
    
    func createEntity() -> Entity {
        let entity = Entity()
        entities.append(entity)
        return entity
    }
    
    func addComponent(_ component: Component, to entity: Entity) {
        let id = entity.id
        
        if let position = component as? PositionComponent {
            positionComponents[id] = position
        } else if let velocity = component as? VelocityComponent {
            velocityComponents[id] = velocity
        } else if let render = component as? RenderComponent {
            renderComponents[id] = render
        }
    }
}
