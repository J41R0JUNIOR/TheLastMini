//
//  ScreenInfo.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 23/07/24.
//

import UIKit

struct ScreenInfo {
    static let shared = ScreenInfo()
    
    private init() {}
    
    func getBoundsSize() -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    func getFrame() -> CGRect {
        return UIScreen.main.bounds
    }
}
