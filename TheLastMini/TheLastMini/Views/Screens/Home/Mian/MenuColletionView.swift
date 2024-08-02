//
//  MenuColletionView.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 25/07/24.
//

import UIKit

class MenuColletionView: UIView {
    
    private var model: [MenuDataModel] = []
    private let size = ScreenInfo.shared.getBoundsSize()
    public var delegate: NavigationDelegate?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: size.width*0.3, height: size.width*0.2)
        layout.sectionInset = UIEdgeInsets(top: 40, left: size.width/3.5, bottom: 0, right: size.width/3.8)
        
        let colletion = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colletion.register(MenuCollectioViewCell.self, forCellWithReuseIdentifier: MenuCollectioViewCell.identifier)
        colletion.delegate = self
        colletion.dataSource = self
        colletion.translatesAutoresizingMaskIntoConstraints = false
        colletion.isPagingEnabled = false
        colletion.showsHorizontalScrollIndicator = false
        colletion.backgroundColor = .clear
        return colletion
    }()

    init(){
        super.init(frame: .zero)
        print("Entered init")
        
        setupViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension MenuColletionView: ViewCode{
    func addViews() {
        addListSubviews(collectionView)
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.centerYAnchor.constraint(equalTo: centerYAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: size.height*0.6)
        ])
    }
    
    func setupStyle() {
        
    }
    
    public func configure(_ model: [MenuDataModel]){
        self.model = model
        self.collectionView.reloadData()
    }
}


extension MenuColletionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectioViewCell.identifier, for: indexPath) as? MenuCollectioViewCell else {
            fatalError("Error in MenuColletionView")
        }
        
        let image = model[indexPath.row].image
        let label = model[indexPath.row].text
        
        cell.configure(image, label)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Clickei no [\(indexPath.row) - \(model[indexPath.row].text)]")
        delegate?.navigationTo(indexPath.row)
    }
    

}
