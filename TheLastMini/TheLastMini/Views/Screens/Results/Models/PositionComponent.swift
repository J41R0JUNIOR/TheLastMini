//
//  PositionComponent.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 10/08/24.
//

import UIKit

class PositionImageComponent: UIView {
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(resource: .p1)
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Gustavo - 00:00"
        label.font = UIFont(name: FontsCuston.fontMediumItalick.rawValue, size: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init(){
        super.init(frame: .zero)
        
        self.setupViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PositionImageComponent: ViewCode{
    func addViews() {
        self.addListSubviews(imageView, label)
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 33),
            
            label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 35),
            label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
        ])
    }
    
    func setupStyle() {
        backgroundColor = .brown
    }
    
    public func configure(with text: String, _ image: UIImage){
        label.text = text
        self.imageView.image = image
    }
}


#Preview{
    PositionImageComponent()
}
