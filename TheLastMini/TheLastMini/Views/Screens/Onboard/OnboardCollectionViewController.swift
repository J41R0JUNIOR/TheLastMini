import UIKit

class OnboardCollectionViewController: UICollectionViewController {
    
    private lazy var onboardCollection: OnboardCollectionView = {
        let view = OnboardCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
        let model: [UIView] = [BasicView(title: PrimaryNames.gameName.rawValue, text: OnboardText.firstPageText.text), BasicView(title: OnboardText.secondPageTitle.text, text: OnboardText.secondPageText.text), BasicView(title: OnboardText.thirdPageTitle.text, text: OnboardText.thirdPageText.text)]
        self.onboardCollection.configure(model)
    }
}

enum PrimaryNames: String {
    case gameName = "Game name"
}

enum OnboardText {
    case firstPageText
    case secondPageTitle
    case secondPageText
    case thirdPageTitle
    case thirdPageText

    var text: String {
        switch self {
        case .firstPageText:
            return "Lorem Ipsum is simply dummy text of the game named \(PrimaryNames.gameName.rawValue) printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        case .secondPageTitle:
            return "What to do?"
        case .secondPageText:
            return "Nothing"
        case .thirdPageTitle:
            return "Nothing to do"
        case .thirdPageText:
            return "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        }
    }
}

