import UIKit

class BasicView: UIView {
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        return label
    }()
    
    private let label2: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let size = ScreenInfo.shared.getBoundsSize()
    
    let title : String
    let text : String
    
    init(title: String, text: String) {
          self.title = title
          self.text = text
          super.init(frame: .zero)
          setupViewCode()
      }
      
      required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
}

extension BasicView: ViewCode{
    func addViews() {
        addSubview(label)
        addSubview(label2)
        
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            label2.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16),
            label2.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label2.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    func setupStyle() {
        self.label.text = self.title
        self.label2.text = self.text
    } 
}
