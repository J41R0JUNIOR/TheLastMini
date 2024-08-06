import UIKit

class OnboardCollectionViewController: UICollectionViewController {
    
    private lazy var onboardCollection: OnboardCollectionView = {
        let view = OnboardCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
//        view.layer.borderColor = .init(red: 0, green: 1, blue: 0, alpha: 1)
//        view.layer.borderWidth = 3
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
//                    view.addSubview(onboardCollection)
            self.view.addSubview(onboardCollection)

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
        let model: [UIView] = [BasicView(title: "Loren", text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."), BasicView(title: "Loren", text: "Loren"), BasicView(title: "Loren", text: "Loren")]
        self.onboardCollection.configure(model)
    }
}
