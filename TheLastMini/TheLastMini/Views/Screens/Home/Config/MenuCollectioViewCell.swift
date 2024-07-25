//
//  MenuCollectioViewCell.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 25/07/24.
//

import UIKit

class MenuCollectioViewCell: UICollectionViewCell {
    
    static let identifier = "MenuCollectioViewCell"
    let size = ScreenInfo.shared.getBoundsSize()
    
    //minigame cell image
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "questionmark")
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 15
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    
    override init(frame: CGRect){
        super.init(frame: frame)
        print("entrei na viewcell menu")
        setupViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MenuCollectioViewCell: ViewCode{
    func addViews() {
        addListSubviews(imageView)
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: size.width*0.6),
            imageView.heightAnchor.constraint(equalToConstant: size.width*0.6),
        ])
    }
    
    func setupStyle() {
        
    }
}
