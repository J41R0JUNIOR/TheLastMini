//
//  MenuColletionView.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 25/07/24.
//

import UIKit

class MenuColletionView: UIView {
    
    let size = ScreenInfo.shared.getBoundsSize()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: size.width*0.60, height: size.width*0.63)
        layout.sectionInset = UIEdgeInsets(top: 10, left: size.width/5, bottom: 0, right: size.width/5)
      
        let colletion = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colletion.register(MenuCollectioViewCell.self, forCellWithReuseIdentifier: MenuCollectioViewCell.identifier)
        colletion.backgroundColor = .clear
        colletion.delegate = self
        colletion.dataSource = self
        colletion.translatesAutoresizingMaskIntoConstraints = false
        colletion.isPagingEnabled = true
        colletion.showsHorizontalScrollIndicator = false
//        colletion.backgroundColor = .red
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
            collectionView.heightAnchor.constraint(equalToConstant: size.width*0.6)
        ])
    }
    
    func setupStyle() {
        
    }
}


extension MenuColletionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCollectioViewCell.identifier, for: indexPath) as? MenuCollectioViewCell else {
            fatalError("Error in MenuColletionView")
        }
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
