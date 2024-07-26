//
//  MenuCollectionViewController.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 25/07/24.
//

import UIKit

class MenuCollectionViewController: UICollectionViewController {

    private lazy var menuColletion: MenuColletionView = {
        let view = MenuColletionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func loadView() {
        self.view = menuColletion
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewCode()
    }

}


extension MenuCollectionViewController: ViewCode{
    func addViews() {
        
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            menuColletion.topAnchor.constraint(equalTo: view.topAnchor),
            menuColletion.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            menuColletion.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuColletion.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupStyle() {

    }
}
