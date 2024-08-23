import UIKit

class OnboardCollectionView: UIView {
    private var model: [UIView] = []
    private let size = ScreenInfo.shared.getBoundsSize()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: size.width, height: size.height)
        
        let collection = UICollectionView(frame: .init(origin: .zero, size: .init(width: size.width, height: size.height)), collectionViewLayout: layout)
        collection.register(OnboardCollectionViewCell.self, forCellWithReuseIdentifier: OnboardCollectionViewCell.identifier)
        collection.delegate = self
        collection.dataSource = self
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        return collection
    }()
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = model.count
        control.currentPage = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        control.pageIndicatorTintColor = .gray
        return control
    }()
    
    private lazy var nextPageButton: UIButton = {
        let button = UIButton()
        button.setTitle(">", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var backPageButton: UIButton = {
        let button = UIButton()
        button.setTitle("<", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setupViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(_ model: [UIView]) {
        self.model = model
        self.pageControl.numberOfPages = model.count
        self.collectionView.reloadData()
    }
}

extension OnboardCollectionView: ViewCode {
    func addViews() {
        addListSubviews(collectionView, pageControl, nextPageButton, backPageButton)
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.pageControl.topAnchor, constant: -self.frame.height * 0.1),
            
            pageControl.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant:  -size.height * 0.05),
            pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            nextPageButton.bottomAnchor.constraint(equalTo: pageControl.bottomAnchor),
            nextPageButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.size.width * 0.1),
            
            backPageButton.bottomAnchor.constraint(equalTo: pageControl.bottomAnchor),
            backPageButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.size.width * 0.1)
        ])
    }
    
    func setupStyle() {
        nextPageButton.addTarget(self, action: #selector(nextIndexPage), for: .touchUpInside)
        backPageButton.addTarget(self, action: #selector(backIndexPage), for: .touchUpInside)
    }
    

    @objc func nextIndexPage(){
        collectionView.isPagingEnabled = false
        let nextIndex = min(pageControl.currentPage + 1, model.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        print(indexPath, nextIndex)
        collectionView.isPagingEnabled = true
        
        pageControl.currentPage = nextIndex
    }
    
    @objc func backIndexPage(){
        collectionView.isPagingEnabled = false
        let previousIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: previousIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        print(indexPath, previousIndex)
        collectionView.isPagingEnabled = true
        
        pageControl.currentPage = previousIndex
    }
}

extension OnboardCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardCollectionViewCell.identifier, for: indexPath) as? OnboardCollectionViewCell else {
            fatalError("Error in OnboardCollectionView")
        }
        
        let showView = model[indexPath.row]
        cell.configure(with: showView)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / size.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
