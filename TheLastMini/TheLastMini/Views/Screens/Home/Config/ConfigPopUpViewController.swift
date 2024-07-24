//
//  ConfigPopUpViewController.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 23/07/24.
//

import UIKit

class ConfigPopUpViewController: UIViewController {
    
    private lazy var configView: ConfigPopUpView = {
        let view = ConfigPopUpView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewCode()
    }
}


extension ConfigPopUpViewController: ViewCode{
    func addViews() {
        view.addListSubviews(configView)
        
        self.configView.delegate = self
        self.configView.switchMusic.delegate = self
        self.configView.switchSoundEfects.delegate = self
        self.configView.switchHaptics.delegate = self
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            configView.topAnchor.constraint(equalTo: view.topAnchor),
            configView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            configView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            configView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func setupStyle() {
        navigationItem.title = "Config"
    }
}

extension ConfigPopUpViewController: NavigationDelegate{
    func navigationTo(_ tag: Int) {
        if tag == 4{
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveLinear, animations: {
                self.view.alpha = 0
            }, completion: { _ in
                self.dismiss(animated: false)
            })
        }
        HapticsService.shared.addHapticFeedbackFromViewController(type: .error)
    }
}

extension ConfigPopUpViewController: ActionDelegate{
    func startAction(_ tag: Int) {
        ///Acoes dos Switchs
        let userDefautl = UserDefaults.standard
        switch tag{
        case 0:
            let music = userDefautl.isActivatedMusic
            userDefautl.isActivatedMusic = !music
        case 1:
            let soundEffects = userDefautl.soundEffects
            userDefautl.soundEffects = !soundEffects
        case 2:
            HapticsService.shared.changeValueIsVibrate()
        default:
            print("Tag Invalida")
        }
    }
}
