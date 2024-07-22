//
//  ConfigButton.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 22/07/24.
//

import UIKit

class ConfigButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        
        self.setupViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ConfigButton: ViewCode{
    func addViews() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addContrains() {
        
    }
    
    func setupStyle() {
        self.setImage(UIImage(systemName: "gear"), for: .normal)
        
    }
}
