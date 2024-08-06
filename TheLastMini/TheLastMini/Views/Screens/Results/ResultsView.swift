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
        label.text = titleMap
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var lapLabels: [UILabel] = []
    private var rankingLabels: [UILabel] = []
    private var totalTimeLabel: UILabel?
    
    private lazy var background: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
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
    
    private func setupStyle() {
        backgroundColor = .black.withAlphaComponent(0.2)
    }
    
    private func setupBackground() {
        addSubview(background)
        
        NSLayoutConstraint.activate([
            background.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            background.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            background.heightAnchor.constraint(equalToConstant: ScreenInfo.shared.getBoundsSize().height*0.7),
            background.widthAnchor.constraint(equalToConstant: ScreenInfo.shared.getBoundsSize().width*0.6),
        ])
    }
    
    private func setupLapLabels() {
        // Remove existing labels
        lapLabels.forEach { $0.removeFromSuperview() }
        lapLabels = []
        
        var lastLabel: UILabel?
      
        for (index, lapTime) in lapTimes.enumerated() {
            let lapLabel = createLabel(text: "Lap \(index + 1) - \(formatTime(lapTime))")
            addSubview(lapLabel)
            lapLabels.append(lapLabel)
            
            // Layout the lap labels
            NSLayoutConstraint.activate([
                lapLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: ScreenInfo.shared.getBoundsSize().width * -0.15),
                lapLabel.topAnchor.constraint(equalTo: lastLabel?.bottomAnchor ?? topAnchor, constant: lastLabel == nil ? -60 : 5)
            ])
            
            lastLabel = lapLabel
        }
    }
    
    private func setupTitleLabel() {
          titleLabel = createLabel(text: titleMap, isBold: true)
          addSubview(titleLabel)
          
          NSLayoutConstraint.activate([
              titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
              titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: ScreenInfo.shared.getBoundsSize().height * -0.3)
          ])
      }
    
    
    private func setupTotalTimeLabel() {
        totalTimeLabel?.removeFromSuperview()
        
        let totalTimeLabel = createLabel(text: "Total - \(formatTime(totalTime))")
        addSubview(totalTimeLabel)
        self.totalTimeLabel = totalTimeLabel
        
        // Layout the total time label
        NSLayoutConstraint.activate([
            totalTimeLabel.centerXAnchor.constraint(equalTo: lapLabels.last?.centerXAnchor ?? leadingAnchor, constant: 0),
            totalTimeLabel.topAnchor.constraint(equalTo: lapLabels.last?.bottomAnchor ?? topAnchor, constant: 15)
        ])
    }
    
    private func setupRankingLabels() {
        // Remove existing labels
        rankingLabels.forEach { $0.removeFromSuperview() }
        rankingLabels = []
        
        let rankingLabel = createLabel(text: "Ranking", isBold: true)
        addSubview(rankingLabel)
        rankingLabels.append(rankingLabel)
        
        // Layout the ranking label
        NSLayoutConstraint.activate([
            rankingLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: ScreenInfo.shared.getBoundsSize().width * 0.15),
            rankingLabel.topAnchor.constraint(equalTo: topAnchor, constant: -80)
        ])
        
        var lastLabel: UILabel = rankingLabel
        for (index, ranking) in rankings.enumerated() {
            let label = createLabel(text: "\(index + 1)º - \(ranking.playerName) | \(ranking.playerBestTime)")
            addSubview(label)
            rankingLabels.append(label)
            
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: centerXAnchor, constant: ScreenInfo.shared.getBoundsSize().width * 0.15),
                label.topAnchor.constraint(equalTo: lastLabel.bottomAnchor, constant: 5)
            ])
            lastLabel = label
        }
    }
    
    private func createLabel(text: String, isBold: Bool = false) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .black
        label.font = isBold ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let milliseconds = Int((time - TimeInterval(minutes * 60) - TimeInterval(seconds)) * 1000)
        return String(format: "%02d:%02d,%03d", minutes, seconds, milliseconds)
    }
}
