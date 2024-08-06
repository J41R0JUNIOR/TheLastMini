import UIKit

class OnboardCollectionViewCell: UICollectionViewCell {
    private let containerView = UIView()
    static let identifier = "onboardCell"

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
         
//        layer.borderColor = .init(red: 1, green: 0, blue: 0, alpha: 1)
//        layer.borderWidth = 3
    }
     
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            containerView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }
    
    func configure(with view: UIView) {
        containerView.subviews.forEach { $0.removeFromSuperview() }
        containerView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            view.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
//            view.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height * 0.1),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.frame.width * 0.1),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(self.frame.width * 0.1))
        ])
    }
}
