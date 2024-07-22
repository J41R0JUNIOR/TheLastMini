//
//  HomeViewController.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 22/07/24.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewModel()
    }
}


extension HomeViewController: ViewModel{
    func addViews() {
        
    }
    
    func addContrains() {
        
    }
    
    func setupStyle() {
        view.backgroundColor = .brown
    }
}
