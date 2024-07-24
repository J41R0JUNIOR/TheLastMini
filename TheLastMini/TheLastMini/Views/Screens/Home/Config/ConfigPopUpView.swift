//
//  ConfigPopUpView.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 23/07/24.
//

import UIKit

class ConfigPopUpView: UIView {

    private lazy var background: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.clipsToBounds = true
        view.layer.cornerRadius = 13
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var buttonBack: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "closeButton"), for: .normal)
        button.tag = 4
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var labelConfig: UILabel = {
        let label = UILabel()
        label.text = "Configurações"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var switchMusic: SwitchViewComponent = {
        let switchC = SwitchViewComponent("Música", 0)
        switchC.translatesAutoresizingMaskIntoConstraints = false
        return switchC
    }()
    
    public lazy var switchSoundEfects: SwitchViewComponent = {
        let switchC = SwitchViewComponent("Efeitos Sonoros", 1)
        switchC.translatesAutoresizingMaskIntoConstraints = false
        return switchC
    }()
    
    public lazy var switchHaptics: SwitchViewComponent = {
        let switchC = SwitchViewComponent("Haptics", 2)
        switchC.translatesAutoresizingMaskIntoConstraints = false
        return switchC
    }()

    
    public weak var delegate: NavigationDelegate?
    
    init(){
        super.init(frame: .zero)
        
        setupViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension ConfigPopUpView: ViewCode{
    func addViews() {
        addListSubviews(background, buttonBack, labelConfig, switchMusic, switchHaptics, switchSoundEfects)
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            background.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            background.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            background.heightAnchor.constraint(equalToConstant: ScreenInfo.shared.getBoundsSize().height*0.5),
            background.widthAnchor.constraint(equalToConstant: ScreenInfo.shared.getBoundsSize().width*0.4),
            
            buttonBack.topAnchor.constraint(equalTo: background.topAnchor, constant: -10),
            buttonBack.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: 5),
            
            labelConfig.topAnchor.constraint(equalTo: background.topAnchor, constant: 10),
            labelConfig.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            
            switchMusic.topAnchor.constraint(equalTo: labelConfig.bottomAnchor, constant: 30),
            switchMusic.centerXAnchor.constraint(equalTo: background.centerXAnchor),
            switchMusic.heightAnchor.constraint(equalToConstant: 35),
            switchMusic.widthAnchor.constraint(equalToConstant: ScreenInfo.shared.getBoundsSize().width*0.35),
            
            switchSoundEfects.topAnchor.constraint(equalTo: switchMusic.bottomAnchor),
            switchSoundEfects.heightAnchor.constraint(equalToConstant: 35),
            switchSoundEfects.widthAnchor.constraint(equalToConstant: ScreenInfo.shared.getBoundsSize().width*0.35),
            switchSoundEfects.centerXAnchor.constraint(equalTo: background.centerXAnchor),

            switchHaptics.topAnchor.constraint(equalTo: switchSoundEfects.bottomAnchor),
            switchHaptics.heightAnchor.constraint(equalToConstant: 35),
            switchHaptics.widthAnchor.constraint(equalToConstant: ScreenInfo.shared.getBoundsSize().width*0.35),
            switchHaptics.centerXAnchor.constraint(equalTo: background.centerXAnchor),

        ])
    }
    
    func setupStyle() {
        backgroundColor = .black.withAlphaComponent(0.4)
    }
}


extension ConfigPopUpView{
    @objc
    private func handleTap(_ sender: UIButton!){
        print("DEBUG: Saindo do popUp de config")
        delegate?.navigationTo(sender.tag)
    }
}
