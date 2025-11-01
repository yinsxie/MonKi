//
//  AudioManager.swift
//  MonKi
//
//  Created by Amelia Morencia Irena on 01/11/25.
//

import AVFoundation

final class AudioManager {
    static let shared = AudioManager()
    private var player: AVAudioPlayer?

    func play(_ name: String, type: String = "m4a", loop: Bool = false) {
        guard let url = Bundle.main.url(forResource: name,
                                        withExtension: type)
        else {
            print("❌ Audio narration not found: \(name)")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = loop ? -1 : 0
            player?.volume = 0.6
            player?.prepareToPlay()
            player?.play()
            print("🎙️ Playing narration: \(name)")
        } catch {
            print("❌ Failed to play narration \(name): \(error.localizedDescription)")
        }
    }

    func stop() {
        player?.stop()
        player = nil
    }
}
