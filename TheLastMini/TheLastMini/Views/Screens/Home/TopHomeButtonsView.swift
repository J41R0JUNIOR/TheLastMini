//
//  TopHomeView.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 22/07/24.
//

import UIKit

class TopHomeButtonsView: UIView {

    private lazy var configButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.backgroundColor = .lightGray.withAlphaComponent(0.5)
        button.layer.cornerRadius = 3.0
        button.tag = 0
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var gameCenterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gamecontroller.fill"), for: .normal)
        button.contentMode = .scaleAspectFill
        button.backgroundColor = .lightGray.withAlphaComponent(0.5)
        button.layer.cornerRadius = 3.0
        button.tag = 1
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Play", for: .normal)
        button.contentMode = .scaleAspectFill
        button.backgroundColor = .lightGray.withAlphaComponent(0.5)
        button.layer.cornerRadius = 3.0
        button.tag = 2
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public weak var delegate: NavigationDelegate?
    
    init(){
        super.init(frame: .zero)
        
        self.setupViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - ViewCode Protocol Methods
extension TopHomeButtonsView: ViewCode{
    func addViews() {
        addListSubviews(configButton, gameCenterButton, playButton)
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            gameCenterButton.widthAnchor.constraint(equalToConstant: 40),
            gameCenterButton.heightAnchor.constraint(equalToConstant: 40),
            gameCenterButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),

            configButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            configButton.widthAnchor.constraint(equalToConstant: 40),
            configButton.heightAnchor.constraint(equalToConstant: 40),
            
            playButton.widthAnchor.constraint(equalToConstant: 40),
            playButton.heightAnchor.constraint(equalToConstant: 40),
            playButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    func setupStyle() {
        backgroundColor = .white
    }
}


//MARK: - Actions
extension TopHomeButtonsView{
    @objc
    private func handleTap(_ sender: UIButton!){
        print("DEBUG: Clickei no Botão -> ", sender.tag)
        delegate?.navigationTo(sender.tag)
    }
}
