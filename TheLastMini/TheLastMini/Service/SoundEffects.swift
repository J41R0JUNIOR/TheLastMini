// SoundEffects.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 05/08/24.
//

import AVFoundation

enum FileName: String {
    case voiceCong = "voiceCong"
    case countSemaforoInit = "race_countdown2-106294-2"
    case countSemaforoFinish = "race_countdown2-106294"
    case soundCong = "soundCong"
}

class SoundManager {
    static let shared = SoundManager()
    private var audioPlayer: AVAudioPlayer?

    private init() {}

    func playSong(fileName: FileName) async {
        await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                guard let url = Bundle.main.url(forResource: fileName.rawValue, withExtension: "mp3") else {
                    print("Erro ao encontrar o arquivo \(fileName.rawValue).mp3")
                    continuation.resume()
                    return
                }

                do {
                    self.audioPlayer = try AVAudioPlayer(contentsOf: url)
                    self.audioPlayer?.prepareToPlay()
                    self.audioPlayer?.play()
                    continuation.resume()
                } catch {
                    print("Erro ao inicializar o AVAudioPlayer: \(error.localizedDescription)")
                    continuation.resume()
                }
            }
        }
    }
}

