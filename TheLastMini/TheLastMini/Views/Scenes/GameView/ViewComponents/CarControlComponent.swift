import Foundation
import UIKit

class CarControlComponent: UIView {
    
    let movementSystem: MovementSystem
    
    var leftButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .green
        button.setTitle("👈🏽", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var rightButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .yellow
        button.setTitle("👉🏽", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let forwardButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .blue
        button.setTitle("👆🏽", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var backwardButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.backgroundColor = .red
        button.setTitle("👇🏽", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var leftStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var rightStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(movementSystem: MovementSystem, frame: CGRect) {
        self.movementSystem = movementSystem
        super.init(frame: frame)
        setupArrowButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupArrowButtons() {
        leftButton.addTarget(self, action: #selector(turnLeftAction), for: .touchDown)
        leftButton.addTarget(self, action: #selector(resetOrientation), for: .touchUpInside)
        
        rightButton.addTarget(self, action: #selector(turnRightAction), for: .touchDown)
        rightButton.addTarget(self, action: #selector(resetOrientation), for: .touchUpInside)
        
        forwardButton.addTarget(self, action: #selector(moveForwardAction), for: .touchDown)
        forwardButton.addTarget(self, action: #selector(resetSpeed), for: .touchUpInside)
        
        backwardButton.addTarget(self, action: #selector(moveBackwardAction), for: .touchDown)
        backwardButton.addTarget(self, action: #selector(resetSpeed), for: .touchUpInside)
        
        leftStack.addListSubviews([leftButton, rightButton])
        addSubview(leftStack)
        
        rightStack.addListSubviews([forwardButton, backwardButton])
        addSubview(rightStack)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Botões na `leftStack`
            leftStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frame.width * 0.05),
            leftStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -120),
            leftStack.widthAnchor.constraint(equalToConstant: 200),
            leftStack.heightAnchor.constraint(equalToConstant: 50),
            
            // Botão para frente
            rightStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -frame.width * 0.025),
            rightStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -180),
            rightStack.widthAnchor.constraint(equalToConstant: 100),
            rightStack.heightAnchor.constraint(equalToConstant: 100),
        ])
        
//        leftStack.spacing = leftStack.frame.width * 0.1
//        rightStack.spacing = rightStack.frame.height * 0.05
    }
    
    func moveForward(_ value: CGFloat = 0.4) {
        movementSystem.engineForce = value
    }
    
    func moveBackward(_ value: CGFloat = -0.4) {
        movementSystem.engineForce = value
    }
    
    func turnRight(_ value: CGFloat = -0.3) {
        movementSystem.steeringAngle = value
    }
    
    func turnLeft(_ value: CGFloat = 0.3) {
        movementSystem.steeringAngle = value
    }
    
    @objc func resetOrientation() {
        movementSystem.steeringAngle = 0.0
    }
    
    @objc func resetSpeed() {
        movementSystem.engineForce = 0
    }
    
    @objc func moveForwardAction() {
        moveForward()
    }
    
    @objc func moveBackwardAction() {
        moveBackward()
    }
    
    @objc func turnRightAction() {
        turnRight()
    }
    
    @objc func turnLeftAction() {
        turnLeft()
    }
}
