//
//  CarControlComponent.swift
//  TheLastMini
//
//  Created by Jairo Júnior on 02/08/24.
//

import Foundation
import UIKit

class CarControlComponent: UIView {
    
    let movementSystem: MovementSystem
    
    init(movementSystem: MovementSystem, frame: CGRect) {
        self.movementSystem = movementSystem
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupControls() {
        let leftButton = UIButton(frame: CGRect(x: 20, y: self.frame.height - 120, width: 100, height: 50))
        leftButton.backgroundColor = .green
        leftButton.setTitle("👈🏽", for: .normal)
        leftButton.addTarget(self, action: #selector(turnLeft), for: .touchDown)
        leftButton.addTarget(self, action: #selector(resetOrientation), for: .touchUpInside)
        self.addSubview(leftButton)
        
        let rightButton = UIButton(frame: CGRect(x: 130, y: self.frame.height - 120, width: 100, height: 50))
        rightButton.backgroundColor = .yellow
        rightButton.setTitle("👉🏽", for: .normal)
        rightButton.addTarget(self, action: #selector(turnRight), for: .touchDown)
        rightButton.addTarget(self, action: #selector(resetOrientation), for: .touchUpInside)
        self.addSubview(rightButton)
        
        let forwardButton = UIButton(frame: CGRect(x: self.frame.width - 120, y: self.frame.height - 180, width: 100, height: 50))
        forwardButton.backgroundColor = .blue
        forwardButton.setTitle("👆🏽", for: .normal)
        forwardButton.addTarget(self, action: #selector(moveForward), for: .touchDown)
        forwardButton.addTarget(self, action: #selector(resetSpeed), for: .touchUpInside)
        self.addSubview(forwardButton)
        
        let backwardButton = UIButton(frame: CGRect(x: self.frame.width - 120, y: self.frame.height - 120, width: 100, height: 50))
        backwardButton.backgroundColor = .red
        backwardButton.setTitle("👇🏼", for: .normal)
        backwardButton.addTarget(self, action: #selector(moveBackward), for: .touchDown)
        backwardButton.addTarget(self, action: #selector(resetSpeed), for: .touchUpInside)
        self.addSubview(backwardButton)
        
        
    }
    
    @objc func moveForward() {
        movementSystem.engineForce = 1
    }
    
    @objc func moveBackward() {
        movementSystem.engineForce = -1
    }
    
    @objc func turnRight() {
        movementSystem.steeringAngle = -0.5
    }
    
    @objc func turnLeft() {
        movementSystem.steeringAngle = 0.5
    }
    
    @objc func resetOrientation() {
        movementSystem.steeringAngle = 0.0
    }
    
    @objc func resetSpeed() {
        movementSystem.engineForce = 0
    }
}
