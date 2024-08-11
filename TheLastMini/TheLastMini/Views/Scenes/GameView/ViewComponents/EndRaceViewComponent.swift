//
//  EndRaceView.swift
//  TheLastMini
//
//  Created by André Felipe Chinen on 02/08/24.
//

import UIKit

class EndRaceView: UIView {

    lazy var endLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Finish!"
        label.textColor = .amarelo
        label.font = UIFont(name: FontsCuston.fontBoldItalick.rawValue, size: 50)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        setupViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension EndRaceView: ViewCode{
    func addViews() {
        self.addListSubviews(endLabel)
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            endLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            endLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func setupStyle() {
        isHidden = true
    }
}
