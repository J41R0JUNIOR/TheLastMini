//
//  Hepatics.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 22/07/24.
//

import UIKit

/*
 * Tipos de feedback tátil disponíveis:
 * - `UINotificationFeedbackGenerator.FeedbackType`: .Sucesso, .Erro, .Aviso.
 * - `UIImpactFeedbackGenerator.FeedbackStyle`: .Leve, .Médio, .Pesado.
 */
class HapticsService{
    
    public let userDefaults = UserDefaults.standard
    /// Singleton instance
    static let shared = HapticsManager()
    
    private init() {}
        
    public func changeValueIsVibrate(){
        let isVibrate = userDefaults.isVibrate
        print("⬆️ Antes ", isVibrate)
        userDefaults.isVibrate = !isVibrate
        print("⬇️ Depois, ", userDefaults.isVibrate)
    }
   
    public func addHapticFeedbackFromViewController(type: UINotificationFeedbackGenerator.FeedbackType){
        let isVibrate = userDefaults.isVibrate
        
        if isVibrate{
            let generetor = UINotificationFeedbackGenerator()
            generetor.prepare()
            generetor.notificationOccurred(type)
        }
    }
    
    public func feedback(for type: UIImpactFeedbackGenerator.FeedbackStyle) {
        let isVibrate = userDefaults.isVibrate
        
        if isVibrate {
            let generator = UIImpactFeedbackGenerator(style: type)
            generator.prepare()
            generator.impactOccurred()
        }
    }
}
