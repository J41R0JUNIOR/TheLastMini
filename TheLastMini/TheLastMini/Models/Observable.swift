//
//  Observable.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 22/07/24.
//

import UIKit

class Observable<T> {
    var value: T {
        didSet {
            observer?(value)
        }
    }
    
    private var observer: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ observer: @escaping (T) -> Void) {
        self.observer = observer
        observer(value)
    }
}

