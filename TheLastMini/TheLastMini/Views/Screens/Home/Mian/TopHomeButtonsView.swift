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
        button.setImage(UIImage(resource: .settinsButton), for: .normal)
        button.contentMode = .scaleAspectFill
        button.tag = 0
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var gameCenterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .gameButton), for: .normal)
        button.contentMode = .scaleAspectFill
        button.tag = 1
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Dragon Road"
        label.font = UIFont(name: FontsCuston.fontBoldItalick.rawValue, size: 26)
        label.textColor = UIColor(resource: .amarelo)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelJapon: UILabel = {
        let label = UILabel()
        label.text = "竜の道"
        label.font = UIFont(name: FontsCuston.fontBoldItalick.rawValue, size: 20)
        label.textColor = UIColor(resource: .amarelo)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stoke: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .amarelo).withAlphaComponent(0.37)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        addListSubviews(configButton, gameCenterButton, label, stoke, labelJapon)
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            gameCenterButton.widthAnchor.constraint(equalToConstant: 60),
            gameCenterButton.heightAnchor.constraint(equalToConstant: 60),
            gameCenterButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            
            stoke.centerXAnchor.constraint(equalTo: label.centerXAnchor),
            stoke.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5),
            stoke.widthAnchor.constraint(equalToConstant: 180),
            stoke.heightAnchor.constraint(equalToConstant: 2),
            
            labelJapon.centerXAnchor.constraint(equalTo: stoke.centerXAnchor),
            labelJapon.topAnchor.constraint(equalTo: stoke.bottomAnchor, constant: 5),
            
            configButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            configButton.widthAnchor.constraint(equalToConstant: 60),
            configButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setupStyle() {
        backgroundColor = .clear
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


#Preview{
    TopHomeButtonsView()
}
