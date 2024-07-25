//
//  HomeViewController.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 22/07/24.
//

import UIKit

class HomeViewController: UIViewController{
    private lazy var topViewButtons: TopHomeButtonsView = {
        let view = TopHomeButtonsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var carouselMenuComponent: MenuCollectionViewController = {
        let view = MenuCollectionViewController()
        view.view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewCode()
    }
}


extension HomeViewController: ViewCode{
    func addViews() {
        addChild(carouselMenuComponent)
        view.addListSubviews(topViewButtons, carouselMenuComponent.view)
        
        self.topViewButtons.delegate = self
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            topViewButtons.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topViewButtons.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topViewButtons.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topViewButtons.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            ///Mark: Mudar depois: Temporario
            topViewButtons.heightAnchor.constraint(equalToConstant: 500),
            
            //CAROUSEL
            carouselMenuComponent.view.topAnchor.constraint(equalTo: view.topAnchor),
            carouselMenuComponent.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            carouselMenuComponent.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselMenuComponent.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    func setupStyle() {
        view.backgroundColor = .white
    }
}

extension HomeViewController: NavigationDelegate{
    func navigationTo(_ tag: Int) {
        switch tag{
        case 0:
            present(ConfigPopUpViewController(), animated: false)
        case 1:
            navigationController?.pushViewController(GameCenterViewController(), animated: true)
        case 2:
            navigationController?.pushViewController(GamePlayViewController(), animated: true)
        default:
            print("Tag invalida")
        }
    }
}
