//
//  Extension.swift
//  TheLastMini
//
//  Created by Jairo Júnior on 31/07/24.
//

import Foundation
import UIKit


extension UIStackView {
    
    func addListSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}

extension TimeInterval{
    var toInt: Int {
        return Int(self)
    }
}

extension UIColor {
    static let transparentLightBlue = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
}
