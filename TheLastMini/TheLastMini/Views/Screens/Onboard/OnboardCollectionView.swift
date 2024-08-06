import UIKit

class OnboardCollectionView: UIView {
    private var model: [UIView] = []
    private let size = ScreenInfo.shared.getBoundsSize()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: size.width/* * 0.9*/, height: size.height /** 0.95*/)
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = size.width * 0.2
//        layout.
      
         
        let collection = UICollectionView(frame: .init(origin: .zero, size: .init(width: size.width, height: size.height)), collectionViewLayout: layout)
        collection.register(OnboardCollectionViewCell.self, forCellWithReuseIdentifier: OnboardCollectionViewCell.identifier)
        collection.delegate = self
        collection.dataSource = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isPagingEnabled = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.isPagingEnabled = true
        
//        collection.layer.borderColor = .init(red: 0, green: 1, blue: 1, alpha: 1)
//        collection.layer.borderWidth = 3
        return collection
    }()
    
    init() {
        super.init(frame: .zero)
        setupViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OnboardCollectionView: ViewCode {
    func addViews() {
        if collectionView != self {
                   addSubview(collectionView)
               }
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.centerYAnchor.constraint(equalTo: centerYAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: size.height * 0.95),
        ])
    }
    
    func setupStyle() {}
    
    public func configure(_ model: [UIView]) {
        self.model = model
        self.collectionView.reloadData()
    }
}

extension OnboardCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardCollectionViewCell.identifier, for: indexPath) as? OnboardCollectionViewCell else {
            fatalError("Error in MenuCollectionView")
        }
        
        let showView = model[indexPath.row]
        cell.configure(with: showView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}
