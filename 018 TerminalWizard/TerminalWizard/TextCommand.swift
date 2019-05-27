//
//  TextCommand.swift
//  TerminalWizard
//
//  Created by Paul Hudson on 26/05/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import Foundation

class TextCommand: CommandOption {
    var title: String
    var prefix: String
    var placeholder: String
    var isNumeric: Bool
    var value: String

    init(title: String, prefix: String, placeholder: String, isNumeric: Bool, value: String) {
        self.title = title
        self.prefix = prefix
        self.placeholder = placeholder
        self.isNumeric = isNumeric
        self.value = value
    }
}
