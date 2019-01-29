//
//  Friend.swift
//  FriendZone
//
//  Created by Paul Hudson on 29/01/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import Foundation

struct Friend: Codable {
    var name: String = "New friend"
    var timeZone: TimeZone = TimeZone.current
}
