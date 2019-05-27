//
//  SelectCommand.swift
//  TerminalWizard
//
//  Created by Paul Hudson on 26/05/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import Foundation

class SelectCommand: CommandOption {
    var title: String
    var prefix: String
    var value: Int
    var friendlyValues: [String]
    var actualValues: [String]

    init(title: String, prefix: String, value: Int, friendlyValues: [String], actualValues: [String]) {
        self.title = title
        self.prefix = prefix
        self.value = value
        self.friendlyValues = friendlyValues
        self.actualValues = actualValues
    }
}
