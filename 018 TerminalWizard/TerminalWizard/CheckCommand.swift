//
//  CheckCommand.swift
//  TerminalWizard
//
//  Created by Paul Hudson on 26/05/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import Foundation

class CheckCommand: CommandOption {
    var title: String
    var prefix: String
    var checkedCommand: String
    var uncheckedCommand: String
    var value: Bool

    init(title: String, prefix: String, checkedCommand: String, uncheckedCommand: String, value: Bool) {
        self.title = title
        self.prefix = prefix
        self.checkedCommand = checkedCommand
        self.uncheckedCommand = uncheckedCommand
        self.value = value
    }
}
