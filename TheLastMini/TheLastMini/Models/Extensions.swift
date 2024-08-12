//
//  Extensions.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 31/07/24.
//

import UIKit


extension TimeInterval{
    var toInt: Int {
        return Int(self)
    }
}

extension Double {
    func formattedWithoutDecimals() -> String {
        return String(format: "%.0f", self)
    }
}

extension UIColor {
    static let transparentLightBlue = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
}
