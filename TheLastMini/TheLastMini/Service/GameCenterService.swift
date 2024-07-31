//
//  GameCenterService.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 31/07/24.
//

import UIKit
import GameKit

class GameCenterService: ObservableObject{
        
    private let localPlayer: GKLocalPlayer = {
        let player = GKLocalPlayer.local
        return player
    }()
    
    static let shared: GameCenterService = GameCenterService()
    
    private init() {}
    
    public func setNewRecord(recordTime: TimeInterval, leaderboardID: Identifier) async {
        do{
            try await GKLeaderboard.submitScore(recordTime.toInt, context: 0, player: self.localPlayer, leaderboardIDs: [leaderboardID.rawValue])
            print("Setado Valor")
        }catch (let error){
            print("ERROR in 'setScore': ", error.localizedDescription)
        }
    }
    
    public func getDataFromGameCenter(leaderboardID: Identifier) async {
        do{
            let leaderboards = try await GKLeaderboard.loadLeaderboards(IDs: [leaderboardID.rawValue])
            
            guard let leaderboard = leaderboards.first else{
                print("Não foi possivel pegar o first de 'leaderboards'.")
                return
            }
            
            let entries = try await leaderboard.loadEntries(for: .global, timeScope: .allTime, range: NSRange(1...5))
            
            if !entries.1.isEmpty{
                entries.1.forEach { playerData in
                    print("Nome: \(playerData.player.displayName) pontuacao: ", playerData.formattedScore)
                }
            }
        }catch (let error){
            print("ERROR in 'getDataFromGameCenter': ", error.localizedDescription)
        }
    }
}




