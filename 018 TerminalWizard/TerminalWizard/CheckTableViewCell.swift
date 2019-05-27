//
//  CheckTableViewCell.swift
//  TerminalWizard
//
//  Created by Paul Hudson on 26/05/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class CheckTableViewCell: UITableViewCell {
    let toggle = UISwitch()
    var switchChangedAction: ((Bool) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        toggle.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        toggle.sizeToFit()
        accessoryView = toggle
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func switchChanged() {
        switchChangedAction?(toggle.isOn)
    }
}
