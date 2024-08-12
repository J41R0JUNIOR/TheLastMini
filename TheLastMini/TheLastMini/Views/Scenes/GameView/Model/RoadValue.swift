//
//  RoadValue.swift
//  TheLastMini
//
//  Created by Jairo Júnior on 12/08/24.
//

import Foundation
import SceneKit

struct RoadModel {
    var roadName: String = ""
    var scale: SCNVector3 = .init(0, 0, 0)
    var checkPointMaxPoints: Int = 0
    
    init(carName: String) {
        switch carName {
        case "Dragon Road":
            self.roadName = "pistaV12.usdz"
            self.scale = SCNVector3(x: 1.5, y: 1, z: 1.5)
            self.checkPointMaxPoints = 10
            
       
        default: break
       
        }
    }
}

enum Roads {
    case roads
    
    var names: [String] {
        switch self {
        case .roads:
            return ["Dragon Road"]
        }
    }
}
