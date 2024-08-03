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
         setupControls()
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     private func setupControls() {
         let leftButton = UIButton(frame: .zero)
         leftButton.backgroundColor = .green
         leftButton.setTitle("👈🏽", for: .normal)
         leftButton.addTarget(self, action: #selector(turnLeft), for: .touchDown)
         leftButton.addTarget(self, action: #selector(resetOrientation), for: .touchUpInside)
         addSubview(leftButton)
         
         let rightButton = UIButton(frame: .zero)
         rightButton.backgroundColor = .yellow
         rightButton.setTitle("👉🏽", for: .normal)
         rightButton.addTarget(self, action: #selector(turnRight), for: .touchDown)
         rightButton.addTarget(self, action: #selector(resetOrientation), for: .touchUpInside)
         addSubview(rightButton)
         
         let forwardButton = UIButton(frame: .zero)
         forwardButton.backgroundColor = .blue
         forwardButton.setTitle("👆🏽", for: .normal)
         forwardButton.addTarget(self, action: #selector(moveForward), for: .touchDown)
         forwardButton.addTarget(self, action: #selector(resetSpeed), for: .touchUpInside)
         addSubview(forwardButton)
         
         let backwardButton = UIButton(frame: .zero)
         backwardButton.backgroundColor = .red
         backwardButton.setTitle("👇🏼", for: .normal)
         backwardButton.addTarget(self, action: #selector(moveBackward), for: .touchDown)
         backwardButton.addTarget(self, action: #selector(resetSpeed), for: .touchUpInside)
         addSubview(backwardButton)
         
         // Configurar Auto Layout
         setupConstraints(leftButton: leftButton, rightButton: rightButton, forwardButton: forwardButton, backwardButton: backwardButton)
     }
     
     private func setupConstraints(leftButton: UIButton, rightButton: UIButton, forwardButton: UIButton, backwardButton: UIButton) {
         leftButton.translatesAutoresizingMaskIntoConstraints = false
         rightButton.translatesAutoresizingMaskIntoConstraints = false
         forwardButton.translatesAutoresizingMaskIntoConstraints = false
         backwardButton.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
             // Botão esquerdo
             leftButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
             leftButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120),
             leftButton.widthAnchor.constraint(equalToConstant: 100),
             leftButton.heightAnchor.constraint(equalToConstant: 50),
             
             // Botão direito
             rightButton.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor, constant: 10),
             rightButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120),
             rightButton.widthAnchor.constraint(equalToConstant: 100),
             rightButton.heightAnchor.constraint(equalToConstant: 50),
             
             // Botão para frente
             forwardButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
             forwardButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -180),
             forwardButton.widthAnchor.constraint(equalToConstant: 100),
             forwardButton.heightAnchor.constraint(equalToConstant: 50),
             
             // Botão para trás
             backwardButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
             backwardButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120),
             backwardButton.widthAnchor.constraint(equalToConstant: 100),
             backwardButton.heightAnchor.constraint(equalToConstant: 50)
         ])
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
