//
//  Wave.swift
//  Zaptastic
//
//  Created by Paul Hudson on 31/03/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import SpriteKit

struct Wave: Codable {
    struct WaveEnemy: Codable {
        let position: Int
        let xOffset: CGFloat
        let moveStraight: Bool
    }

    let name: String
    let enemies: [WaveEnemy]
}
