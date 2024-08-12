import UIKit

class TrackInfoView: UIView {
    
    var lapTimes: [TimeInterval] = [] {
        didSet {
            setupLapLabels()
        }
    }
    
    var rankings: [PlayerTimeRankModel] = [] {
        didSet {
            setupRankingLabels()
        }
    }
    
    var totalTime: TimeInterval = 0 {
        didSet {
            setupTotalTimeLabel()
        }
    }
    
    var titleMap: String = ""{
        didSet {
            setupTitleLabel()
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Dragon Road"
        label.font = UIFont(name: FontsCuston.fontBoldItalick.rawValue, size: 26)
        label.textColor = UIColor(resource: .amarelo)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var lapLabels: [UILabel] = []
    private var rankingLabels: [PositionImageComponent] = []
    private var totalTimeLabel: UILabel?
    
    private lazy var background: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .bgBlue)
        view.clipsToBounds = true
        view.layer.cornerRadius = 13
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInitialLayout()
    }
    
    private func setupInitialLayout() {
        setupStyle()
        setupBackground()
        setupTitleLabel()
        setupLapLabels()
        setupTotalTimeLabel()
        setupRankingLabels()
    }
    
    private lazy var stroke1: UIView = {
        let view = UIView()
        view.backgroundColor = .amarelo
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stroke2: UIView = {
        let view = UIView()
        view.backgroundColor = .amarelo
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func setupStyle() {
        backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    private func setupBackground() {
        addSubview(background)
        addSubview(stroke1)
        addSubview(stroke2)
        
        NSLayoutConstraint.activate([
            background.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            background.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            background.heightAnchor.constraint(equalToConstant: ScreenInfo.shared.getBoundsSize().height*0.9),
            background.widthAnchor.constraint(equalToConstant: ScreenInfo.shared.getBoundsSize().width*0.8),
        ])
    }
    
    private func setupLapLabels() {
        lapLabels.forEach { $0.removeFromSuperview() }
        lapLabels = []
        
        var lastLabel: UILabel?
      
        for (index, lapTime) in lapTimes.enumerated() {
                    let lapLabel = createLabel(text: "Lap \(index + 1) - \(formatTime(lapTime))")
                    addSubview(lapLabel)
                    lapLabels.append(lapLabel)
                 
            // Layout the lap labels
            NSLayoutConstraint.activate([
                lapLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: ScreenInfo.shared.getBoundsSize().width * -0.22),
                lapLabel.topAnchor.constraint(equalTo: lastLabel?.bottomAnchor ?? topAnchor, constant: lastLabel == nil ? -50 : 5)
            ])
            
            lastLabel = lapLabel
        }
        
        NSLayoutConstraint.activate([
            stroke1.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            stroke1.centerXAnchor.constraint(equalTo: self.background.centerXAnchor),
            stroke1.heightAnchor.constraint(equalToConstant: 2),
            stroke1.widthAnchor.constraint(equalTo: background.widthAnchor, multiplier: 0.8),
            
            stroke2.topAnchor.constraint(equalTo: self.stroke1.bottomAnchor, constant: 20),
            stroke2.centerXAnchor.constraint(equalTo: self.background.centerXAnchor),
            stroke2.heightAnchor.constraint(equalTo: background.widthAnchor, multiplier: 0.28),
            stroke2.widthAnchor.constraint(equalToConstant: 2),
        ])
    }
    
    private func setupTitleLabel() {
          addSubview(titleLabel)
          
          NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.background.topAnchor, constant: 15),
              titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
          ])
      }
    
    
    private func setupTotalTimeLabel() {
        totalTimeLabel?.removeFromSuperview()
        
        let totalLabel = createLabel(text: "Your times", isBold: false)
        totalLabel.font = UIFont(name: FontsCuston.fontLightItalick.rawValue, size: 24)
        totalLabel.textColor = .amarelo
        
        let totalTimeLabel = createLabel(text: "Total - \(formatTime(totalTime))")
        totalTimeLabel.textColor = .red
        
        let record = createLabel(text: "Your Record - \(UserDefaults.standard.timeRecord)")
        record.textColor = .amarelo
        record.translatesAutoresizingMaskIntoConstraints = false

        addSubview(totalTimeLabel)
        addSubview(totalLabel)
        addSubview(record)
        self.totalTimeLabel = totalTimeLabel
        
        // Layout the total time label
        NSLayoutConstraint.activate([
            totalTimeLabel.centerXAnchor.constraint(equalTo: lapLabels.last?.centerXAnchor ?? leadingAnchor, constant: -3),
            totalTimeLabel.topAnchor.constraint(equalTo: lapLabels.last?.bottomAnchor ?? topAnchor, constant: 10),
            
            totalLabel.topAnchor.constraint(equalTo: stroke1.bottomAnchor, constant: 10),
            totalLabel.leadingAnchor.constraint(equalTo: self.background.leadingAnchor, constant: 93),
            
            record.trailingAnchor.constraint(equalTo: self.background.trailingAnchor, constant: -55),
            record.bottomAnchor.constraint(equalTo: self.background.bottomAnchor, constant: -30),
        ])
    }
    
    private func setupRankingLabels() {
        // Remove existing labels
        rankingLabels.forEach { $0.removeFromSuperview() }
        rankingLabels = []
        
        let rankingLabel = createLabel(text: "Ranking", isBold: false)
        rankingLabel.font = UIFont(name: FontsCuston.fontLightItalick.rawValue, size: 24)
        rankingLabel.textColor = .amarelo
        addSubview(rankingLabel)
        
        // Layout the ranking label
        NSLayoutConstraint.activate([
            rankingLabel.topAnchor.constraint(equalTo: stroke1.bottomAnchor, constant: 10),
            rankingLabel.leadingAnchor.constraint(equalTo: self.stroke2.trailingAnchor, constant: 40)
        ])
        
        var lastLabel: PositionImageComponent?
        
        for (index, ranking) in rankings.enumerated() {
            let label = PositionImageComponent()
            label.configure(with: "\(ranking.playerName.prefix(8)) - \(ranking.playerBestTime)", UIImage(named: "p\(index+1)") ?? UIImage(resource: .gameButton))
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
            rankingLabels.append(label)
            
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: centerXAnchor, constant: ScreenInfo.shared.getBoundsSize().width * 0.19),
                label.topAnchor.constraint(equalTo: lastLabel?.bottomAnchor ?? rankingLabel.bottomAnchor, constant: 40)
            ])
            
            lastLabel = label
        }
    }
    
    private func createLabel(text: String, isBold: Bool = false) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: FontsCuston.fontMediumItalick.rawValue, size: 20)
        label.textColor = UIColor(resource: .bg)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview{
    ResultsViewController(map: "")
}
