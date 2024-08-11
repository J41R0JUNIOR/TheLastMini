import UIKit

protocol ResultsViewControllerDelegate: AnyObject {
    func backTapped()
}

class ResultsViewController: UIViewController {
    
    private lazy var trackInfoView: TrackInfoView = {
        let view = TrackInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(resource: .goBack), for: .normal)
        backButton.contentMode = .scaleAspectFill
        backButton.addTarget(self, action: #selector(handle), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        return backButton
    }()
    
    
    private var laps: [TimeInterval] = []
    private var rank : [PlayerTimeRankModel] = []
    private var map : String
    
    private var gameCenterService = GameCenterService.shared
    
    weak var delegate: ResultsViewControllerDelegate?
    
    init(map: String) {
        self.map = mockMapTitle
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewCode()
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
            setupTrackInfoView(mockLapTimes)
//            setupBackButton()
        }
    }
    
    
    public func setupTrackInfoView(_ laps: [TimeInterval]) {
        trackInfoView.lapTimes = laps
        trackInfoView.totalTime = sumTotalTime()
        trackInfoView.rankings = rank
        trackInfoView.titleMap = map
        
//        trackInfoView.lapTimes = mockLapTimes
//        trackInfoView.totalTime = mockTotalTime
//        trackInfoView.rankings = mockRankings
//        trackInfoView.titleMap = mockMapTitle
    }
    
    public func saveTimeRecord() {
        let userDefault = UserDefaults.standard

        if userDefault.timeRecord == 0 || userDefault.timeRecord > sumTotalTime() {
            userDefault.timeRecord = sumTotalTime()
            Task {
                await gameCenterService.setNewRecord(recordTime: sumTotalTime(), leaderboardID: .recordID)
            }
        }
    }
    
    @objc
    private func handle() {
        HapticsService.shared.addHapticFeedbackFromViewController(type: .success)
        dismiss(animated: true)
        delegate?.backTapped()
    }
    
    private func sumTotalTime()-> TimeInterval {
        return laps.reduce(0, +)
    }
}

extension ResultsViewController: ViewCode{
    func addViews() {
        self.view.addListSubviews(trackInfoView, backButton)
    }
    
    func addContrains() {
        NSLayoutConstraint.activate([
            backButton.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: ScreenInfo.shared.getBoundsSize().height * 0.43),
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            backButton.h.constraint(equalToConstant: 40),
            
            trackInfoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackInfoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            trackInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            trackInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupStyle() {
        
    }
}

#Preview{
    ResultsViewController(map: "Dragon Road")
}

// Mockando alguns dados para testar
let mockLapTimes: [TimeInterval] = [
    60.5,  // 1 minuto e 0.5 segundos
    58.2,  // 58 segundos e 200 milissegundos
    62.7   // 1 minuto e 2.7 segundos
]

let mockRankings: [PlayerTimeRankModel] = [
    PlayerTimeRankModel(playerName: "Jogador 1", playerBestTime: "00:55"),
    PlayerTimeRankModel(playerName: "Jogador 2", playerBestTime: "00:57"),
    PlayerTimeRankModel(playerName: "Jogador 3", playerBestTime: "00:59"),
    PlayerTimeRankModel(playerName: "Jogador 4", playerBestTime: "00:59")
]

let mockTotalTime: TimeInterval = mockLapTimes.reduce(0, +) // Somando o tempo total

let mockMapTitle: String = "Drakon Road"
