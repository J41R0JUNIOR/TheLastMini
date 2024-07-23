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
public class Hepatics{
    
    public let userDefaults = UserDefaults.standard
//    static let shared: Hepatics = Hepatics()
    
    /*private*/ init(){}
   
    public func addHapticFeedbackFromViewController(type: UINotificationFeedbackGenerator.FeedbackType){
        let isVibrate = userDefaults.isVibrate!
        
        if isVibrate{
            let generetor = UINotificationFeedbackGenerator()
            generetor.notificationOccurred(type)
        }
    }
    
    public func feedback(for type: UIImpactFeedbackGenerator.FeedbackStyle) {
        let isVibrate = userDefaults.isVibrate
        print("\n\n😈DEBUG: Valor de isVibrate e ", isVibrate as Any)
        
        if isVibrate! {
            let generator = UIImpactFeedbackGenerator(style: type)
            generator.prepare()
            generator.impactOccurred()
        }
    }
}
