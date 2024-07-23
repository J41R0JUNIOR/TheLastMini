//
//  Delegates.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 23/07/24.
//

import Foundation

//Navegação para outras views como: Config, gampley e etc.
protocol NavigationDelegate: AnyObject{
    func navigationTo(_ tag: Int)
}

//Ações de switchs.
protocol ActionDelegate: AnyObject{
    func startAction(_ tag: Int)
}
