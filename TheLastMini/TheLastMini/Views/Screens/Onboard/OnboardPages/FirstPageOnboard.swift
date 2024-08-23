import UIKit

class FirstPageOnboad: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let label2: UILabel = {
        let label = UILabel()
        label.textAlignment = .justified
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "AppIcon"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    
    private let size = ScreenInfo.shared.getBoundsSize()
    
    let title: String
    let text: String
    let image: UIImage
    
    init(title: String, text: String, image: UIImage) {
        self.title = title
        self.text = text
        self.image = image
        super.init(frame: .zero)
        setupViewCode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FirstPageOnboad: ViewCode {
    func addViews() {
        addSubview(label)
        addSubview(label2)
        addSubview(imageView)
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            // Constraints for the first label
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),

            // Constraints for the second label
            label2.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            label2.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            label2.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),

            // Constraints for the image view
            imageView.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),

//            imageView.heightAnchor.constraint(equalToConstant: 200) // Ajuste conforme necessário
        ])
    }
    
    func setupStyle() {
        self.label.text = self.title
        self.label2.text = self.text
        self.imageView.image = self.image
    }
}

#Preview {
    FirstPageOnboad(title: "Bem-vindo", text: "Este é o Kuruma Driver!", image: UIImage(named: "sua_imagem")!)
}


//addContrains
