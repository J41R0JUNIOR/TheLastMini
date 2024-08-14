//
//  Component.swift
//  TheLastMini
//
//  Created by Jairo Júnior on 31/07/24.
//

import Foundation
import ARKit
import SceneKit

// Identificador único para cada entidade
typealias Entity = SCNNode

// Componentes base
protocol Component {}

// Componente de física do veículo
struct VehiclePhysicsComponent: Component {
    let vehicle: SCNPhysicsVehicle
//    let wheels: [SCNPhysicsVehicleWheel]
}

// Componente de posição
struct PositionComponent: Component {
    var position: SCNVector3
}



