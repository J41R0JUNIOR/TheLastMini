import AVFoundation
import SceneKit

enum FileName: String {
    case voiceCong = "voiceCong"
    case countSemaforoInit = "race_countdown2-106294-2"
    case countSemaforoFinish = "race_countdown2-106294"
    case soundCong = "soundCong"
    case idlCar = "02-0807"
    case startCar = "01-nissan_skyline_r34"
    case accelerateCar1 = "CarAudioV2"
    case accelerateCar3 = "03-nissan_skyline_r34"
}

enum TypeSound {
    case soundEffect, music
}

class SoundManager{
    static let shared = SoundManager()
    public var audioPlayer: AVAudioPlayer?
    private let userDefualt: UserDefaults = UserDefaults.standard

    private init() {}

    public func playSong(fileName: FileName, _ type: TypeSound) async {
        if type == .music && userDefualt.isActivatedMusic {
            await self.startSong(fileName: fileName)
        } else if type == .soundEffect && userDefualt.soundEffects {
            await self.startSong(fileName: fileName)
        }
    }
    
    private func startSong(fileName: FileName) async {
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
    

    private func setupVolume(fileName: FileName) -> Float {
        if fileName == .accelerateCar1 || fileName == .accelerateCar3 {
            return 0.2
        }
        return 0.5
    }

    public func changeVolume(_ volumeValue: Double) {
        guard let player = self.audioPlayer else {
            print("SCNAudioSource Invalido")
            return
        }

        let normalizedVolume = min(1.0, volumeValue / 10.0)
        let volumeInt = Int(normalizedVolume * 100)

        guard volumeInt > 0 else {
            player.rate = 0.8
            while(player.volume > 0.2) {
                player.volume -= 0.1
            }
            return
        }
        player.volume = Float(volumeInt) / 100.0
        player.rate = 1
    }
}

