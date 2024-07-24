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
        case soundEffects
        case isActivatedMusic
    }
    
    var soundEffects: Bool {
        get{
            let value = value(forKey: UserDefaultsKeys.soundEffects.rawValue) as? Bool ?? true
            return (value)
        }
        set{
            setValue(newValue, forKey: UserDefaultsKeys.soundEffects.rawValue)
        }
    }
    
    var isActivatedMusic: Bool {
        get{
            let value = value(forKey: UserDefaultsKeys.isActivatedMusic.rawValue) as? Bool ?? true
            return (value)
        }
        set{
            setValue(newValue, forKey: UserDefaultsKeys.isActivatedMusic.rawValue)
        }
    }
    
    var isVibrate: Bool {
        get{
            let value = value(forKey: UserDefaultsKeys.isVibrate.rawValue) as? Bool ?? true
            return (value)
        }
        set{
            setValue(newValue, forKey: UserDefaultsKeys.isVibrate.rawValue)
        }
    }
}
