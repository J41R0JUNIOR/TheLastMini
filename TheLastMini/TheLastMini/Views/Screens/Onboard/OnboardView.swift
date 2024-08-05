//
//  OnboardView.swift
//  TheLastMini
//
//  Created by Jairo Júnior on 05/08/24.
//

import Foundation
import UIKit

enum Text: String {
    case gameName = "TheLastMini"
}


class OnboardCollectionViewCell: UICollectionViewCell{
    static let identifier = "OnboardCollectionViewCell"
    
}

class OnboardCollectionView: UIView {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
//        layout.itemSize = .init
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(OnboardCollectionViewCell.self, forCellWithReuseIdentifier: OnboardCollectionViewCell.identifier)
        collection.delegate = self
//        collection.dataSource = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isPagingEnabled = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        return collection
    }()
    
}

extension OnboardCollectionView: UICollectionViewDelegate{
    
}







#Preview{
    OnboardCollectionView()
}
