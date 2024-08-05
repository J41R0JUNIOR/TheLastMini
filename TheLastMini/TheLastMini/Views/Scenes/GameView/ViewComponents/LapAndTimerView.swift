//
//  LapAndTimerView.swift
//  TheLastMini
//
//  Created by André Felipe Chinen on 02/08/24.
//

import UIKit

class LapAndTimerView: UIView {
    
    private lazy var lapLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Lap 1/3"
        label.textColor = .white
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0:00,0"
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    lazy var timer: Timer = {
        let t = Timer()
        return t
    }()
    
    public var currentLap = 1 {
        didSet {
            lapLabel.text = "Lap \(currentLap)/3"
        }
    }
    
    public var minutos = 0
    public var segundos = 0
    public var decimos = 0

    init() {
        super.init(frame: .zero)
        
        setupViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func playTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(step), userInfo: nil, repeats: true)
    }
    
    public func pauseTimer() {
        timer.invalidate()
    }
    
    public func addLap() {
        currentLap += 1
    }
    
    @objc private func step() {
        decimos += 1
        if decimos == 10 {
            decimos = 0
            segundos += 1
            if segundos == 60 {
                segundos = 0
                minutos += 1
            }
        }
        if segundos >= 0 && segundos < 10 {
            timerLabel.text = "\(minutos):0\(segundos),\(decimos)"
        } else {
            timerLabel.text = "\(minutos):\(segundos),\(decimos)"
        }
    }

}

extension LapAndTimerView: ViewCode{
    func addViews() {
        self.addListSubviews(lapLabel, timerLabel)
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            lapLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            timerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func setupStyle() {
        isHidden = true
    }
}
