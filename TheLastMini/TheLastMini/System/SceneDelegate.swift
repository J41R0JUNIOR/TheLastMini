//
//  SceneDelegate.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 22/07/24.
//

import UIKit
import GameKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        Task{
           await requestPermission()
        }
        
        let user = UserDefaults.standard
        
        print(user.timeRecord, " Bla Bla Bla")
        self.window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController(rootViewController: HomeViewController() /*GameView()*/)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    public func requestPermission() async {
        let localPlayer = GameCenterService.shared.localPlayer
        localPlayer.authenticateHandler = { (viewController, error) in
            if let viewController = viewController{
                viewController.present(viewController, animated: true)
            }else if localPlayer.isAuthenticated{
                print("Permissão ativada")
            }else {
                print("Player não authenticated")
                if let error = error{
                    print("ERROR in 'requestPermission': ", error.localizedDescription)
                }
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
}

