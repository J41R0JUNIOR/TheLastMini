//
//  ConfigPopUpViewController.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 23/07/24.
//

import UIKit

class ConfigPopUpViewController: UIViewController {
    
    private let userDefaults = UserDefaults.standard

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
            UIView.animate(withDuration: 1, delay: 0.3,options: .curveEaseOut) {
                self.view.alpha = 1
            }completion: { _ in
                self.dismiss(animated: false)
            }
        }
    }
}

extension ConfigPopUpViewController: ActionDelegate{
    func startAction(_ tag: Int) {
        switch tag{
        case 0:
            print("Switch Musica acao")
        case 1:
            print("Switch sound efects acao")
        case 2:
            let isVibrate = userDefaults.isVibrate
            userDefaults.isVibrate = !isVibrate!
        default:
            print("Tag Invalida")
        }
    }
}
