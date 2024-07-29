//
//  Components.swift
//  TheLastMini
//
//  Created by Jairo Júnior on 29/07/24.
//

import Foundation
import SceneKit

protocol Component {}

struct PositionComponent: Component {
    var x: Double
    var y: Double
    var z: Double
}

struct VelocityComponent: Component {
    var x: Double
    var y: Double
    var z: Double
}

struct RenderComponent: Component {
    var node: SCNNode
}
