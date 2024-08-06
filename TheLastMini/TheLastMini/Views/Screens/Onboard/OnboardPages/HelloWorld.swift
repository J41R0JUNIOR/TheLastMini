import UIKit

class HelloWorldView: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.text = "What is Lorem Ipsum?"
        label.textAlignment = .center
        label.textColor = .purple
//        label.layer.borderColor = UIColor.red.cgColor
        label.layer.borderWidth = 1 // Opcional: para uma borda mais fina
        label.numberOfLines = 0 // Allow label to wrap text
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        return label
    }()
    
    private let label2: UILabel = {
        let label = UILabel()
        label.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        label.textAlignment = .center
        label.textColor = .purple
//        label.layer.borderColor = UIColor.red.cgColor
        label.layer.borderWidth = 1 // Opcional: para uma borda mais fina
        label.numberOfLines = 0 // Allow label to wrap text
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.layer.borderColor = .init(red: 1, green: 1, blue: 1, alpha: 1)
        label.layer.borderWidth = 4
        return label
    }()
    
    private let size = ScreenInfo.shared.getBoundsSize()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(label)
        addSubview(label2)
        
        NSLayoutConstraint.activate([
            // Constraints for the first label
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            
//            label.widthAnchor.constraint(equalTo: self.widthAnchor),
//            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            
            // Constraints for the second label
            label2.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
//            label2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label2.widthAnchor.constraint(equalToConstant: size.width * 0.9),
            label2.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            label2.trailingAnchor.constraint(equalTo: label.trailingAnchor),
//            label2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
//            label2.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
}
