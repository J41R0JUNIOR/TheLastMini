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
            let vehicleValues = VehicleValues()
            self.chassisName = vehicleValues.chassis
            self.lWheelName = vehicleValues.lWheel
            self.rWheelName = vehicleValues.rWheel
            self.xWheel = vehicleValues.x
            self.yWheel = vehicleValues.y
            self.zfWheel = vehicleValues.zf
            self.zbWheel = vehicleValues.zb
            self.suspensionRestLength = vehicleValues.suspensionRestLength
            self.suspensionStiffness = vehicleValues.suspensionStiffness
        default: break
       
        }
    }
}

struct VehicleValues {
    let chassis = "Car_Chassis_3-2.usdz"
    let lWheel = "Left_Wheel_3-2.usdz"
    let rWheel = "Right_Wheel_3-2.usdz"
    let x = 0.025
    let y = -0.01
    let zf = 0.0388
    let zb = 0.02
    let suspensionRestLength = 0.04
    let suspensionStiffness = 50.0
}
