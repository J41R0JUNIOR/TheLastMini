//
//  UserDefult.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 23/07/24.
//

import Foundation

extension UserDefaults{
    //MARK: Enum que define um case do tipo String
    private enum UserDefaultsKeys: String{
        case isVibrate
    }
    
    var isVibrate: Bool? {
        get{
//            print("\n\t Valor e ", self.isVibrate as Any)
            let value = value(forKey: UserDefaultsKeys.isVibrate.rawValue) as? Bool ?? true
            return (value)
        }
        set{
//            print("\n\t Settei Valor e ", isVibrate as Any)
            setValue(newValue, forKey: UserDefaultsKeys.isVibrate.rawValue)
        }
    }
}
