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
    
    
    public var laps: [TimeInterval] = []
    private var rank : [PlayerTimeRankModel] = []
    private var map : String
    
    private var gameCenterService = GameCenterService.shared
    
    weak var delegate: ResultsViewControllerDelegate?
    
    init(map: String) {
        self.map = "Dragon Road"
        
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
        Task{
            await SoundManager.shared.playSong(fileName: .musicaFoda, .music)
        }
//        setupRank()
    }
    
    public func setupRank() {
        Task {
            await gameCenterService.fetchData(leaderboardID: .recordID)
            for player in gameCenterService.playersData {
                rank.append(PlayerTimeRankModel(playerName: player.name, playerBestTime: player.score))
            }
            setupTrackInfoView()
//            setupBackButton()
        }
    }
    
    
    private func setupTrackInfoView() {
        trackInfoView.lapTimes = self.laps
        trackInfoView.totalTime = sumTotalTime()
        trackInfoView.rankings = rank
        trackInfoView.titleMap = map
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


