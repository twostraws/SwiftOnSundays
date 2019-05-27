//
//  CommandOption.swift
//  TerminalWizard
//
//  Created by Paul Hudson on 26/05/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import Foundation

protocol CommandOption {
    var title: String { get }
    var prefix: String { get }
}
