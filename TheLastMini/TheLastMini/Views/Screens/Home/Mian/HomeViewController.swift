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
        
    private lazy var backGround: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(resource: .bg)
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var start: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .play), for: .normal)
        button.contentMode = .scaleAspectFill
        button.tag = 2
        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var carouselMenuComponent: MenuCollectionViewController = {
        let viewController = MenuCollectionViewController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        return viewController
    }()
    
    public var gameCenterVC: GKGameCenterViewController?
    private let haptics: HapticsService = HapticsService.shared
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewCode()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
}


extension HomeViewController: ViewCode{
    func addViews() {
        addChild(carouselMenuComponent)
        view.addListSubviews(backGround, carouselMenuComponent.view, topViewButtons, start)

        self.topViewButtons.delegate = self
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            topViewButtons.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            topViewButtons.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            topViewButtons.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            topViewButtons.heightAnchor.constraint(equalToConstant: 50),
            
            //CAROUSEL
            carouselMenuComponent.view.topAnchor.constraint(equalTo: topViewButtons.bottomAnchor),
            carouselMenuComponent.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            carouselMenuComponent.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselMenuComponent.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            //BACKGROUND
            backGround.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backGround.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backGround.widthAnchor.constraint(equalToConstant: view.frame.height*2.8),
            backGround.heightAnchor.constraint(equalToConstant: view.frame.height),
            
            //START
            start.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            start.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            start.widthAnchor.constraint(equalToConstant: 180),
            start.heightAnchor.constraint(equalToConstant: 55),
        ])
    }
    
    func setupStyle() {
        view.backgroundColor = UIColor(resource: .bgBlue)
    }
    
    
    private func newInstanceGameCenter(){
        let newGameCenterVC = GKGameCenterViewController(leaderboardID: Identifier.recordID.rawValue, playerScope: .global, timeScope: .allTime)
        newGameCenterVC.gameCenterDelegate = self
        gameCenterVC = newGameCenterVC
    }
    
    @objc
    private func handleTap(_ sender: UIButton!){
        navigationTo(sender.tag)
    }
}

extension HomeViewController: NavigationDelegate{
    func navigationTo(_ tag: Int) {
        haptics.feedback(for: .light)
        switch tag{
        case 0:
            UIView.animate(withDuration: 0.1, delay: 0.08, options: .curveLinear, animations: {
                self.view.alpha = 1
            }, completion: { _ in
                self.present(ConfigPopUpViewController(), animated: false)
            })
        case 1:
            newInstanceGameCenter()
            present(gameCenterVC!, animated: true)
        case 2:
            let carValues = VehicleModel(carName: Cars.models.names[0])
            let roadValues = RoadModel(carName: Roads.roads.names[0])
            navigationController?.pushViewController(GameView(vehicleModel: carValues, roadModel: roadValues), animated: true)
        default:
            print("Tag invalida")
        }
    }
}

extension HomeViewController: GKGameCenterControllerDelegate{
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        HapticsService.shared.addHapticFeedbackFromViewController(type: .error)
        gameCenterVC?.dismiss(animated: true)
        gameCenterVC = nil
    }
}

#Preview{
    HomeViewController()
}
