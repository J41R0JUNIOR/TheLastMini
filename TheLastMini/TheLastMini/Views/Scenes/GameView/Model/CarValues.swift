//
//  CarValues.swift
//  TheLastMini
//
//  Created by Jairo Júnior on 08/08/24.
//

import Foundation


struct VehicleModel {
    var chassisName: String = ""
    var lWheelName: String = ""
    var rWheelName: String = ""
    var xWheel: Double = 0.0
    var yWheel: Double = 0.0
    var zfWheel: Double = 0.0
    var zbWheel: Double = 0.0
    var suspensionRestLength: Double = 0.0
    var suspensionStiffness: Double = 0.0
    
    init(carName: String) {
        switch carName {
        case "Model1":
            self.chassisName = "Car_Chassis_3-2.usdz"
            self.lWheelName = "Left_Wheel_3-2.usdz"
            self.rWheelName = "Right_Wheel_3-2.usdz"
            self.xWheel = 0.025
            self.yWheel = -0.01
            self.zfWheel = 0.0388
            self.zbWheel = 0.02
            self.suspensionRestLength = 0.04
            self.suspensionStiffness = 50.0
        default: break
       
        }
    }
}
