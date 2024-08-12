//
//  TrafficLightComponent.swift
//  TheLastMini
//
//  Created by Jairo Júnior on 01/08/24.
//

import Foundation
import UIKit


class TrafficLightComponent: UIView{    
    private lazy var light1: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(resource: .light1Apagado)
        return view
    }()
    
    private lazy var light2: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(resource: .light2Apagado)
        return view
    }()
    
    private lazy var light3: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(resource: .light3Apagado)
        return view
    }()
    
    weak var delegate: TrafficLightDelegate?
    
    private let soundManager: SoundManager = SoundManager.shared

    private var allGreen = false

    override init(frame: CGRect) {
        super.init(frame: frame)
       
        self.isHidden = true
        SetupTrafficLight()
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
        
        NSLayoutConstraint.activate([
            trafficLightStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            trafficLightStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        [light1, light2, light3].forEach { light in
            light.widthAnchor.constraint(equalToConstant: lightSize).isActive = true
            light.heightAnchor.constraint(equalToConstant: lightSize).isActive = true
//            light.layer.cornerRadius = lightSize / 2
        }
    }
    
    func startAnimation() {
        var count = 0
        let lights = [light1, light2, light3]
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if count == 3 {
                Task{
                    await self.soundManager.playSong(fileName: .countSemaforoFinish, .soundEffect)
                }
            } else if count == 4 {
                self.allGreen = true
                self.delegate?.changed()
                timer.invalidate()
            } else {
                Task{
                    await self.soundManager.playSong(fileName: .countSemaforoInit, .soundEffect)
                }
                HapticsService.shared.feedback(for: .rigid)
                lights[count].image = UIImage(named: "light\(count+1)Ligado")
            }
            count += 1
        }
    }

}


protocol TrafficLightDelegate: AnyObject {
    func changed()
}
