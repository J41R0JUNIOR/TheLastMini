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
        view.backgroundColor = UIColor(named: "bgColor")
        view.clipsToBounds = true
        view.layer.cornerRadius = 13
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "bgPopUp")
        image.clipsToBounds = true
        image.layer.cornerRadius = 13
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var buttonBack: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backButton"), for: .normal)
        button.tag = 4
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var labelConfig: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor(named: "amarelo")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public lazy var switchMusic: SwitchViewComponent = {
        let switchC = SwitchViewComponent("Music", 0)
        switchC.translatesAutoresizingMaskIntoConstraints = false
        return switchC
    }()
    
    public lazy var switchSoundEfects: SwitchViewComponent = {
        let switchC = SwitchViewComponent("Sounds", 1)
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
        
        background.addSubview(image)
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            background.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            background.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            background.heightAnchor.constraint(equalToConstant: ScreenInfo.shared.getBoundsSize().height*0.58),
            background.widthAnchor.constraint(equalToConstant: ScreenInfo.shared.getBoundsSize().width*0.48),
            
            image.centerXAnchor.constraint(equalTo: self.background.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: self.background.centerYAnchor),
            
            buttonBack.topAnchor.constraint(equalTo: background.topAnchor, constant: 3),
            buttonBack.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -3),
            
            labelConfig.topAnchor.constraint(equalTo: background.topAnchor, constant: 10),
            labelConfig.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 20),
            
            switchMusic.topAnchor.constraint(equalTo: labelConfig.bottomAnchor, constant: 30),
            switchMusic.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 20),
            switchMusic.heightAnchor.constraint(equalToConstant: 35),
            switchMusic.widthAnchor.constraint(equalToConstant: ScreenInfo.shared.getBoundsSize().width*0.35),
            
            switchMusic.switchCuston.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 125),
            
            switchSoundEfects.topAnchor.constraint(equalTo: switchMusic.bottomAnchor),
            switchSoundEfects.heightAnchor.constraint(equalToConstant: 35),
            switchSoundEfects.widthAnchor.constraint(equalToConstant: ScreenInfo.shared.getBoundsSize().width*0.35),
            switchSoundEfects.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 20),

            switchHaptics.topAnchor.constraint(equalTo: switchSoundEfects.bottomAnchor),
            switchHaptics.heightAnchor.constraint(equalToConstant: 35),
            switchHaptics.widthAnchor.constraint(equalToConstant: ScreenInfo.shared.getBoundsSize().width*0.35),
            switchHaptics.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 20),

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

#Preview{
    ConfigPopUpView()
}
