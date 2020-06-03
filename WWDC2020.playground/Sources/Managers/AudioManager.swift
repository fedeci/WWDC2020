import Foundation
import AVFoundation

final class AudioManager {
    static let shared = AudioManager()
    
    private(set) var playing: MusicType?
    private(set) var volume: Float = 0.2
    private var backgroundPlayer: AVAudioPlayer?
    
    enum MusicType {
        case main
        case game
    }
    
    func playBackgroundMusic(type: MusicType) {
        var resource: String
        var rate: Float
        
        switch type {
        case .main:
            resource = "MainMusic.mp3"
            rate = 0.5
        case .game:
            resource = "GameMusic.mp3"
            rate = 1.0
        }
        
        if let url = Bundle.main.url(forResource: resource, withExtension: nil) {
            do {
                try backgroundPlayer = AVAudioPlayer(contentsOf: url)
                backgroundPlayer?.stop()
                backgroundPlayer?.numberOfLoops = -1
                backgroundPlayer?.rate = rate
                backgroundPlayer?.enableRate = true
                backgroundPlayer?.volume = volume
                backgroundPlayer?.prepareToPlay()
                backgroundPlayer?.play()
            } catch {
                print("Cannot create audio player.")
                return
            }
            
            playing = type
        }
    }
    
    func setVolume(to volume: Float) {
        backgroundPlayer?.setVolume(volume, fadeDuration: 0)
        self.volume = volume
    }
}
