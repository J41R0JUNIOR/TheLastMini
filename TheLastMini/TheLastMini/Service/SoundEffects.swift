// SoundEffects.swift
//  TheLastMini
//
//  Created by Gustavo Horestee Santos Barros on 05/08/24.
//

import AVFoundation
import SceneKit

enum FileName: String {
    case voiceCong = "voiceCong"
    case countSemaforoInit = "race_countdown2-106294-2"
    case countSemaforoFinish = "race_countdown2-106294"
    case soundCong = "soundCong"
    case idlCar = "car-idle-84718"
    case startCar = "01-nissan_skyline_r34"
    case accelerateCar1 = "02-nissan_skyline_r34"
    case accelerateCar3 = "03-nissan_skyline_r34"
}

class SoundManager {
    static let shared = SoundManager()
    private var audioPlayer: AVAudioPlayer?

    private init() {}

   public func playSong(fileName: FileName) async {
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
    
    public func loadCarAudio(_ fileName: FileName, _ isLoop: Bool) -> SCNAudioSource{
        guard let audio = SCNAudioSource(fileNamed: fileName.rawValue) else {
            print("ERROR in 'loadCarAudio': Falha em carregar audio.")
            return SCNAudioSource()
        }
        
        audio.loops = isLoop
        audio.isPositional = true
        audio.shouldStream = false
        audio.load()
        
        return audio
    }
}

