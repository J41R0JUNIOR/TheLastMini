import UIKit

protocol ResultsViewControllerDelegate {
    func backTapped()
}

class ResultsViewController: UIViewController {
    
    private var trackInfoView: TrackInfoView!
    var laps: [TimeInterval] = []
    var rank : [PlayerTimeRankModel] = []
    var map : String
    
    private var gameCenterService = GameCenterService.shared
    
    var delegate: ResultsViewControllerDelegate?
    
    init(map: String) {
        self.map = map
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupRank()
    }
    
    public func setupRank() {
        Task {
            await gameCenterService.fetchData(leaderboardID: .recordID)
            for player in gameCenterService.playersData {
                rank.append(PlayerTimeRankModel(playerName: player.name, playerBestTime: player.score))
            }
            setupTrackInfoView()
            setupBackButton()
        }
    }
    
    
    public func setupTrackInfoView() {
        trackInfoView = TrackInfoView()
        trackInfoView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackInfoView)
        
        // Example data
        trackInfoView.lapTimes = laps
        trackInfoView.totalTime = sumTotalTime()
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
            backButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: ScreenInfo.shared.getBoundsSize().height * 0.25),
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    public func saveTimeRecord() {
        let userDefault = UserDefaults.standard
        print("Record: ", userDefault.timeRecord)

        if userDefault.timeRecord == 0 || userDefault.timeRecord > sumTotalTime() {
            userDefault.timeRecord = sumTotalTime()
            print("✅ Valor: ", userDefault.timeRecord)
            Task {
                await gameCenterService.setNewRecord(recordTime: sumTotalTime(), leaderboardID: .recordID)
            }
        }
    }
    
    @objc private func backButtonTapped() {
        // Handle back button tap
        print("Back to home Tapped")
        dismiss(animated: true)
        delegate?.backTapped()
    }
    
    private func sumTotalTime()-> TimeInterval {
        return laps.reduce(0, +)
    }
}

