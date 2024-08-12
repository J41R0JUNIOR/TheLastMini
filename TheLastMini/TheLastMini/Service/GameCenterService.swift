//
//  GameCenterService.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 31/07/24.
//

import UIKit
import GameKit

class GameCenterService: ObservableObject{
     
    static let shared: GameCenterService = GameCenterService()

    public let localPlayer: GKLocalPlayer = {
        let player = GKLocalPlayer.local
        
        return player
    }()

    @Published private(set) var playersData: [Player] = []
        
    private init() {}
    
    deinit{
        self.playersData = []
    }
    
    private func reseatData(){
        self.playersData = []
    }
    
    public func setNewRecord(recordTime: TimeInterval, leaderboardID: Identifier) async {
        print("Valor timeInterval: ", recordTime, " [-] Valor int: ", recordTime.toInt)
        do{
            try await GKLeaderboard.submitScore(recordTime.toInt, context: 0, player: self.localPlayer, leaderboardIDs: [leaderboardID.rawValue])
            print("Setado Valor")
        }catch (let error){
            print("ERROR in 'setScore': ", error.localizedDescription)
        }
    }
    
    public func fetchData(leaderboardID: Identifier) async {
        self.reseatData()
        do{
            let leaderboards = try await GKLeaderboard.loadLeaderboards(IDs: [leaderboardID.rawValue])
            
            guard let leaderboard = leaderboards.first else{
                print("Não foi possivel pegar o first de 'leaderboards'.")
                return
            }
            
            let entries = try await leaderboard.loadEntries(for: .global, timeScope: .allTime, range: NSRange(1...4))
            
            if !entries.1.isEmpty{
                entries.1.forEach { playerData in
                    print("Nome: \(playerData.player.displayName) pontuacao: ", playerData.formattedScore)
                    self.playersData.append(Player(name: playerData.player.displayName, score: playerData.formattedScore, position: playerData.rank))
                }
            }
        }catch (let error){
            print("ERROR in 'getDataFromGameCenter': ", error.localizedDescription)
        }
    }
}




