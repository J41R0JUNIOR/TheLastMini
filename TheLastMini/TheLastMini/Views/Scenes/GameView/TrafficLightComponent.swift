//
//  TrafficLightComponent.swift
//  TheLastMini
//
//  Created by Jairo Júnior on 01/08/24.
//

import Foundation
import UIKit


class TrafficLightComponent: UIView{    
    let light1 = UIView()
    let light2 = UIView()
    let light3 = UIView()
    
     var delegate: TrafficLightDelegate?
    
    private var allGreen = false

    override init(frame: CGRect) {
        super.init(frame: frame)
       
        self.isHidden = true
        SetupTrafficLight()
//        lightAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func SetupTrafficLight() {
        
        let lightSize: CGFloat = self.frame.width/3
        
        let trafficLightStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [light1, light2, light3])
            stackView.alignment = .center
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.distribution = .equalSpacing
            stackView.axis = .horizontal
            
            return stackView
        }()
        
        addSubview(trafficLightStackView)
        
        // Configuração das constraints do stackView
        NSLayoutConstraint.activate([
            trafficLightStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            trafficLightStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        // Configuração das luzes
        [light1, light2, light3].forEach { light in
            light.widthAnchor.constraint(equalToConstant: lightSize).isActive = true
            light.heightAnchor.constraint(equalToConstant: lightSize).isActive = true
            light.layer.cornerRadius = lightSize / 2
            light.backgroundColor = .gray
        }
    }
    
    func startAnimation() {
        light1.backgroundColor = .yellow
        var count = 0
        let lights = [light1, light2, light3]
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            
            if count == 3 {
                for light in lights {
                    light.backgroundColor = .green
                }
            } else if count == 4 {
                self.allGreen = true
                self.delegate?.changed()
                timer.invalidate()
            } else {
                lights[count].backgroundColor = .yellow
            }
            
            count += 1
        }
    }

}


protocol TrafficLightDelegate {
    func changed()
}
