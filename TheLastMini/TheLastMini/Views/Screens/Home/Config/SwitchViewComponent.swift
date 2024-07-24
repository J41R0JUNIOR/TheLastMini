//
//  SwitchViewComponent.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 23/07/24.
//

import UIKit

class SwitchViewComponent: UIView {
    
    private lazy var switchCuston: UISwitch = {
        let switchC = UISwitch()
        switchC.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        switchC.translatesAutoresizingMaskIntoConstraints = false
        return switchC
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "nil"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public weak var delegate: ActionDelegate?
    private let defult = UserDefaults.standard
    
    init(_ label: String, _ tag: Int){
        super.init(frame: .zero)
        
        self.setupViewCode()
        self.configure(label, tag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension SwitchViewComponent: ViewCode{
    func addViews() {
        addListSubviews(switchCuston, label)
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            switchCuston.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func setupStyle() {
//        backgroundColor = .red
    }
}

extension SwitchViewComponent{
    @objc 
    func handleTap(_ sender: UIButton!){
        print("DEBUG: Valor de Switch [\(label.text ?? "nil")] mudou para [\(switchCuston.isOn)]")
        delegate?.startAction(sender.tag)
    }
    
    private func configure(_ label: String, _ tag: Int){
        self.label.text = label
        self.switchCuston.tag = tag
        if label == "Haptics"{
            self.switchCuston.isOn = defult.isVibrate
        }
    }
}
