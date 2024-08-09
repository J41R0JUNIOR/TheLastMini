import Foundation
import ARKit
import FocusNode
import SmartHitTest


extension ARSCNView: ARSmartHitTest { }

//MARK: - Configuração de animação de scan
extension GameView: ARCoachingOverlayViewDelegate{
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print("Vai comecar ✅")
    }
    
    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        print("Sera que foi agora? 🐐")
        if !shouldHandleResetRequest{
            shouldHandleResetRequest = true
            coachingOverlayView.removeFromSuperview()
            configureFocusNode()
            setupTapGesture()
            return
        }
        
    }
}

//MARK: Função de action replace and play button
extension GameView: NavigationDelegate{
    func navigationTo(_ tag: Int) {
        switch tag{
        case 10:
            print("Replace")
            if sceneView.scene.rootNode.childNodes.count > 0{
                sceneView.scene.rootNode.childNodes.forEach { node in
                    if node.name != "focusNode"{
                        node.removeFromParentNode()
                    }
                }
                self.isVehicleAdded = false
                self.replaceAndPlay.toggleVisibility()
                focusNode.isHidden = false
                self.tapGesture?.isEnabled = true
            }
        case 11:
            print("Play")
            setupControls()
            self.replaceAndPlay.toggleVisibility()
            self.trafficLightComponent.isHidden = false
            self.trafficLightComponent.startAnimation()
        default:
            print("ERROR in 'GameView->navigationTo': Tag invalida")
        }
    }
}

extension GameView: ViewCode{
    func addViews() {
        self.view.addListSubviews(sceneView, replaceAndPlay, coachingOverlay, trafficLightComponent, lapAndTimer, endView, carControlViewComponent)
        
        self.replaceAndPlay.delegate = self
        self.trafficLightComponent.delegate = self
        self.focusNode.viewDelegate = sceneView
        self.focusNode.name = "focusNode"
        carControlViewComponent.isHidden = true
        self.resumoViewComponent.delegate = self

    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            coachingOverlay.topAnchor.constraint(equalTo: self.view.topAnchor),
            coachingOverlay.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            coachingOverlay.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            coachingOverlay.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            replaceAndPlay.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            replaceAndPlay.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            replaceAndPlay.heightAnchor.constraint(equalToConstant: 41),
            replaceAndPlay.widthAnchor.constraint(equalToConstant: 280),
            
            trafficLightComponent.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trafficLightComponent.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            lapAndTimer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            lapAndTimer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            lapAndTimer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            lapAndTimer.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            lapAndTimer.heightAnchor.constraint(equalToConstant: 50),
            
            endView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            endView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            carControlViewComponent.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carControlViewComponent.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carControlViewComponent.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            carControlViewComponent.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func setupStyle() {
        
    }
}

extension GameView: ResultsViewControllerDelegate {
    func backTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}
