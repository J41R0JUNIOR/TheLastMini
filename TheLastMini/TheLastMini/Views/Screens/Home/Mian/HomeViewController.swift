//
//  HomeViewController.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 22/07/24.
//

import UIKit
import GameKit

class HomeViewController: UIViewController{
    private lazy var topViewButtons: TopHomeButtonsView = {
        let view = TopHomeButtonsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private lazy var carouselMenuComponent: MenuCollectionViewController = {
        let viewController = MenuCollectionViewController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        return viewController
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Selecione um Mapa"
        label.font = .systemFont(ofSize: 16, weight: .black)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public var gameCenterVC: GKGameCenterViewController?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewCode()
    }
}


extension HomeViewController: ViewCode{
    func addViews() {
        addChild(carouselMenuComponent)
        view.addListSubviews(carouselMenuComponent.view, topViewButtons, label)

        self.topViewButtons.delegate = self
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            topViewButtons.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topViewButtons.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topViewButtons.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topViewButtons.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            topViewButtons.heightAnchor.constraint(equalToConstant: 50),
            
            //CAROUSEL
            carouselMenuComponent.view.topAnchor.constraint(equalTo: view.topAnchor),
            carouselMenuComponent.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            carouselMenuComponent.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselMenuComponent.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            
            label.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
        ])
    }
    
    func setupStyle() {
        view.backgroundColor = .white
    }
    
    
    private func newInstanceGameCenter(){
        let newGameCenterVC = GKGameCenterViewController(leaderboardID: Identifier.recordID.rawValue, playerScope: .global, timeScope: .allTime)
        newGameCenterVC.gameCenterDelegate = self
        gameCenterVC = newGameCenterVC
    }
}

extension HomeViewController: NavigationDelegate{
    func navigationTo(_ tag: Int) {
        switch tag{
        case 0:
            present(ConfigPopUpViewController(), animated: false)
        case 1:
            newInstanceGameCenter()
            present(gameCenterVC!, animated: true)
        case 2:
            navigationController?.pushViewController(GamePlayViewController(), animated: true)
        default:
            print("Tag invalida")
        }
    }
}

extension HomeViewController: GKGameCenterControllerDelegate{
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterVC?.dismiss(animated: true)
        gameCenterVC = nil
    }
}
