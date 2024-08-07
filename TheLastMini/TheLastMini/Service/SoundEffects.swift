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
    case idlCar = "02-0807.mp3"
    case startCar = "01-nissan_skyline_r34.mp3"
    case accelerateCar1 = "01-0807.mp3"
    case accelerateCar3 = "03-nissan_skyline_r34.mp3"
}

enum TypeSound{
    case soundEffect, music
}

class SoundManager {
    static let shared = SoundManager()
    private var audioPlayer: AVAudioPlayer?
    private let userDefualt: UserDefaults = UserDefaults.standard

    private init() {}

    public func playSong(fileName: FileName, _ type: TypeSound) async {
        if type == .music && userDefualt.isActivatedMusic == true{
            await self.startSoung(fileName: fileName)
        }else if type == .soundEffect && userDefualt.soundEffects == true{
            await self.startSoung(fileName: fileName)
        }
    }
    
    private func startSoung(fileName: FileName) async{
        await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                guard let url = Bundle.main.url(forResource: fileName.rawValue, withExtension: "mp3") else {
                    print("Erro ao encontrar o arquivo \(fileName.rawValue)")
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
    
    public func changeVolume(_ player: SCNAudioPlayer, _ volume: Double){
        player.audioSource?.volume = Float(volume)
    }
}

