//
//  ViewCodeProtocols.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 22/07/24.
//

import UIKit

// Extensão que permite adicionar mais de uma view à hierarquia em uma única chamada. Exemplo: addViews(label1, label2, button1, button2)
extension UIView {
    func addSubviewsEx(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}

protocol ViewModel {
    // Adiciona views como subviews e define a hierarquia entre elas
    func addViews()
    
    // Define as constraints a serem usadas para posicionar os elementos na view
    func addContrains()
    
    // Define os estilos da view, como cor, bordas, etc.
    func setupStyle()
}

// Chama todos os métodos do protocolo
extension ViewModel {
    func setupViewModel() {
        addViews()
        addContrains()
        setupStyle()
    }
}


