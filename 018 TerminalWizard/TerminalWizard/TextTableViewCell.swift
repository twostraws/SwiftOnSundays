//
//  TextTableViewCell.swift
//  TerminalWizard
//
//  Created by Paul Hudson on 26/05/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell, UITextFieldDelegate {
    let textField = UITextField()
    var textChangedAction: ((String) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.delegate = self
        textField.tag = 0xDEADBEEF
        contentView.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            textField.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func textFieldChanged() {
        textChangedAction?(textField.text ?? "")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
