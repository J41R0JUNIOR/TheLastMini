//
//  HomeViewController.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 22/07/24.
//

import UIKit

class HomeViewController: UIViewController{
    private lazy var configButton: ConfigButton = {
       return ConfigButton()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewCode()
    }
}


extension HomeViewController: ViewCode{
    func addViews() {
        view.addListSubviews(configButton)
    }
    
    func addContrains() {
        configButton.center = view.center
    }
    
    func setupStyle() {
        view.backgroundColor = .systemBackground
    }
}
