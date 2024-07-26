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
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "nil"
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "questionmark.app.fill")
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
        addListSubviews(imageView, label)
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: size.width*0.3),
            imageView.heightAnchor.constraint(equalToConstant: size.width*0.2),
            
            label.bottomAnchor.constraint(equalTo: imageView.topAnchor),
            label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
        ])
    }
    
    func setupStyle() {
        self.backgroundColor = .blue.withAlphaComponent(0.4)
    }
}

extension MenuCollectioViewCell{
    public func configure(_ image: UIImage, _ label: String){
        self.imageView.image = image
        self.label.text = label
    }
}
