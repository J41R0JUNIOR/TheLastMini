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
        let model: [UIView] = [
                   FirstPageOnboad(title: PrimaryNames.gameName.rawValue, text: OnboardText.firstPageText.text, image: UIImage(named: "AppIcon")!),
                   HowToPlayPageOnboad(title: OnboardText.howToPlay.text, text: OnboardText.secondPageText.text, image: UIImage(named: "posicionar")!),
                   HowToPlayPageOnboad(title: OnboardText.howToPlay.text, text: OnboardText.thirdPageText.text, image: UIImage(named: "jogar")!),
                   HowToPlayPageOnboad(title: OnboardText.howToPlay.text, text: OnboardText.fourthPageText.text)
               ]
        self.onboardCollection.configure(model)
    }
}

enum PrimaryNames: String {
    case gameName = "Kuruma Driver"
}

enum OnboardText {
    case firstPageText
    case howToPlay
    case secondPageText
    case thirdPageText
    case fourthPageText

    var text: String {
        switch self {
        case .firstPageText:
            return """
                    Welcome to \(PrimaryNames.gameName.rawValue)!\n
                    Get ready for an exciting Augmented Reality racing experience!\n In \(PrimaryNames.gameName.rawValue), you don't just play, you live the race in the real world.
                    """
        case .howToPlay:
            return "How to Play?"
        case .secondPageText:
            return """
                    Position the Track: Place a racing track on the ground using your device. The track will be projected into your surroundings, making each race unique.
                    """
        case .thirdPageText:
            return """
                     Drive the Car: Use the intuitive buttons to control your car:
                     Accelerate to gain speed.
                     Brake to slow down and make safer turns.
                     Left and Right to steer the car along the course.
                    """
        case .fourthPageText:
            return """
                     Avoid Obstacles: Watch out for obstacles on the track. They can affect drivability and challenge your control skills.
                     Compete with Friends: Show off your skills and see who’s the best driver! Each player's lap time is recorded and compared, allowing you to compete for the best time.
            """
        }
    }
}
