//
//  Quote.swift
//  InnerPeace
//
//  Created by Paul Hudson on 03/02/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import Foundation

struct Quote: Codable {
    var text: String
    var author: String

    var shareMessage: String {
        return "\"\(text)\" — \(author)"
    }
}
