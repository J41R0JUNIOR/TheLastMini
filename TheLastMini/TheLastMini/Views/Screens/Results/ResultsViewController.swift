import UIKit

class ResultsViewController: UIViewController {
    
    private var trackInfoView: TrackInfoView!
    var laps : [TimeInterval]
    var rank : [PlayerTimeRankModel]
    var map : String
    
    init(laps: [TimeInterval], rank: [PlayerTimeRankModel], map: String) {
        self.laps = laps
        self.rank = rank
        self.map = map
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTrackInfoView()
        setupBackButton()
    }
    
    private func setupTrackInfoView() {
        trackInfoView = TrackInfoView()
        trackInfoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackInfoView)
        
        // Example data
        trackInfoView.lapTimes = laps
        trackInfoView.totalTime = 94.061
        trackInfoView.rankings = rank
        trackInfoView.titleMap = map
        
        // Layout the track info view
        NSLayoutConstraint.activate([
            trackInfoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackInfoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            trackInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            trackInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setTitle("Back to home", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backButton)
        
        // Layout the back button
        NSLayoutConstraint.activate([
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func backButtonTapped() {
        // Handle back button tap
        dismiss(animated: true, completion: nil)
    }
}

let lapTimes = [33.561, 28.832, 32.757]
let totalTime = 94.061
let rankings = [
        PlayerTimeRankModel(playerName: "Gustavo", playerBestTime: 92.327),
        PlayerTimeRankModel(playerName: "Jairo", playerBestTime: 94.061),
        PlayerTimeRankModel(playerName: "Ishida", playerBestTime: 96.943),
        PlayerTimeRankModel(playerName: "Fernanda", playerBestTime: 101.755),
        PlayerTimeRankModel(playerName: "Andrezin", playerBestTime: 102.322)
]
let map = "Mount Fuji Track"
#Preview{
    ResultsViewController(laps: lapTimes , rank: rankings, map: map)
}
