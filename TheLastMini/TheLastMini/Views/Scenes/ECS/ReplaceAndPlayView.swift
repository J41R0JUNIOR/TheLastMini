//
//  ReplaceButtonActionView.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 01/08/24.
//

import UIKit

class ReplaceAndPlayView: UIView {
    
    private lazy var replace: UIButton = {
        let button = UIButton()
//        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.setTitle("Reposicionar", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .lightGray.withAlphaComponent(0.5)
        button.layer.cornerRadius = 3.0
        button.tag = 10
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var play: UIButton = {
        let button = UIButton()
//        button.setImage(UIImage(systemName: "gear"), for: .normal)
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .lightGray.withAlphaComponent(0.5)
        button.layer.cornerRadius = 3.0
        button.tag = 11
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public weak var delegate: NavigationDelegate?
    
    init() {
        super.init(frame: .zero)
        
        setupViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ReplaceAndPlayView: ViewCode{
    func addViews() {
        self.addListSubviews(replace, play)
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            self.replace.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -72),
            self.replace.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            self.replace.heightAnchor.constraint(equalToConstant: 40),
            self.replace.widthAnchor.constraint(equalToConstant: 130),
            
            self.play.leadingAnchor.constraint(equalTo: self.replace.trailingAnchor, constant: 15),
            self.play.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            self.play.heightAnchor.constraint(equalToConstant: 40),
            self.play.widthAnchor.constraint(equalToConstant: 130),
        ])
    }
    
    func setupStyle() {
        self.backgroundColor = .clear 
    }
}

extension ReplaceAndPlayView{
    @objc
    private func handleTap(_ sender: UIButton!){
        print(sender.tag)
        delegate?.navigationTo(sender.tag)
    }
    
    public func toggleVisibility(){
        self.isHidden.toggle()
    }
}


#Preview{
    ReplaceAndPlayView()
}
