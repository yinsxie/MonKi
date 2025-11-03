//
//  SoundManager.swift
//  MonKi
//
//  Created by Amelia Morencia Irena on 01/11/25.
//

import AVFoundation

final class SoundManager {
    static let shared = SoundManager()
    private var player: AVAudioPlayer?

    enum Sound: String {
        case buttonClick
        case cancelAction
        case cropDone
        case drawPencil
        case eraseCanvas
        case getSeed
        case logSuccess
        case pickCrayon
        case popUredo
        case pourWater
        case readyHarvest
        case shovelClick
        case tagClick
        
        var normalizedVolume: Float {
                switch self {
                case .buttonClick: return 0.9   // kecilin dikit
                case .pourWater:   return 0.8   // biar agak besar
                case .shovelClick: return 1.0
                case .pickCrayon: return 1.2
                case .tagClick:    return 0.6
                case .popUredo: return 0.7
                case .cancelAction: return 1.2
                default:           return 0.8
                }
        }
    }

    func play(_ sound: Sound) {
        guard let url = Bundle.main.url(
            forResource: sound.rawValue,
            withExtension: "mp3"
        ) else {
            print("❌ SFX file not found: \(sound.rawValue)")
            return
        }

        do {
            // Setiap kali dipanggil, buat player baru (biar overlap bisa jalan)
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = sound.normalizedVolume
            player?.prepareToPlay()
            player?.play()
            print("🔊 Playing \(sound.rawValue) at volume \(sound.normalizedVolume)")
        } catch {
            print("❌ Failed to play \(sound.rawValue): \(error.localizedDescription)")
        }
    }
    func stop(){
        player?.stop()
        player = nil
    }
}
