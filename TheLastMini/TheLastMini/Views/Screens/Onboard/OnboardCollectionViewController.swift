import UIKit

class OnboardCollectionViewController: UICollectionViewController {
    
    private lazy var onboardCollection: OnboardCollectionView = {
        let view = OnboardCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
//        view.layer.borderColor = .init(red: 0, green: 1, blue: 0, alpha: 1)
        view.layer.borderWidth = 3
        return view
    }() 
    
    override func loadView() {
        self.view = onboardCollection
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewCode()
        setupCells()
    }
}

extension OnboardCollectionViewController: ViewCode {
    func addViews() {
        if onboardCollection != self.view {
                    view.addSubview(onboardCollection)
                }
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            onboardCollection.topAnchor.constraint(equalTo: view.topAnchor),
            onboardCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            onboardCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            onboardCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupStyle() {}
    
    func setupCells() {
        let model: [UIView] = [HelloWorldView(), HelloWorldView(), HelloWorldView()] // Exemplos de views
        self.onboardCollection.configure(model)
    }
}
