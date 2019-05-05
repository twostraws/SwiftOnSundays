//
//  SoundPlaying.swift
//  WatchReactions WatchKit Extension
//
//  Created by Paul Hudson on 05/05/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import AVFoundation

protocol SoundPlaying: AnyObject {
    var audioPlayer: AVAudioPlayer? { get set }
}

extension SoundPlaying {
    func playSound(named name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            fatalError("Unable to find sound file \(name).mp3")
        }

        try? audioPlayer = AVAudioPlayer(contentsOf: url)
        audioPlayer?.play()
    }
}
