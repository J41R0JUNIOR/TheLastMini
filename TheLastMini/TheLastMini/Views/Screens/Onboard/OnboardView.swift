import UIKit

class OnboardView: UIViewController {
    private lazy var carouselOnboardingComponent: OnboardCollectionViewController = {
        let viewController = OnboardCollectionViewController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return viewController
    }() 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewCode()
    }
}

extension OnboardView: ViewCode {
   
    
    func addViews() { 
        self.view.addSubview(carouselOnboardingComponent.view)
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            carouselOnboardingComponent.view.topAnchor.constraint(equalTo: view.topAnchor),
            carouselOnboardingComponent.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            carouselOnboardingComponent.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselOnboardingComponent.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupStyle() {}
}

#Preview{
    OnboardView()
}
