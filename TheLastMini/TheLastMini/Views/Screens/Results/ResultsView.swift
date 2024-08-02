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
    
    private var titleLabel: UILabel!
    private var lapLabels: [UILabel] = []
    private var rankingLabels: [UILabel] = []
    private var totalTimeLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInitialLayout()
    }
    
    private func setupInitialLayout() {
        setupTitleLabel()
        setupLapLabels()
        setupTotalTimeLabel()
        setupRankingLabels()
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
                lapLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 130),
                lapLabel.topAnchor.constraint(equalTo: lastLabel?.bottomAnchor ?? topAnchor, constant: lastLabel == nil ? -60 : 25)
            ])
            
            lastLabel = lapLabel
        }
    }
    
    private func setupTitleLabel() {
          titleLabel = createLabel(text: titleMap, isBold: true)
          addSubview(titleLabel)
          
          NSLayoutConstraint.activate([
              titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
              titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: -160)
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
            rankingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -130),
            rankingLabel.topAnchor.constraint(equalTo: topAnchor, constant: -80)
        ])
        
        var lastLabel: UILabel = rankingLabel
        for (index, ranking) in rankings.enumerated() {
            let label = createLabel(text: "\(index + 1)º - \(ranking.playerName) | \(formatTime(ranking.playerBestTime))")
            addSubview(label)
            rankingLabels.append(label)
            
            NSLayoutConstraint.activate([
                label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
                label.topAnchor.constraint(equalTo: lastLabel.bottomAnchor, constant: 10)
            ])
            lastLabel = label
        }
    }
    
    private func createLabel(text: String, isBold: Bool = false) -> UILabel {
        let label = UILabel()
        label.text = text
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
