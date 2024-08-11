import AVFoundation
import SceneKit

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
    
    public func stop(){
        self.audioPlayer?.stop()
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
                     self.audioPlayer?.volume = self.setupVolume(fileName: fileName)
                     self.audioPlayer?.numberOfLoops = self.looping(fileName: fileName)
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
    
    private func looping(fileName: FileName) -> Int {
        if fileName == .musicaFoda{
            return -1
        }
        return 0
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

