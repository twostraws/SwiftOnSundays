//
//  EditCommandViewController.swift
//  TerminalWizard
//
//  Created by Paul Hudson on 26/05/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class EditCommandViewController: UITableViewController {
    var activeCommand: Command!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = activeCommand.friendlyName

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Select")
        tableView.register(CheckTableViewCell.self, forCellReuseIdentifier: "Check")
        tableView.register(TextTableViewCell.self, forCellReuseIdentifier: "Text")
        tableView.keyboardDismissMode = .onDrag
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return activeCommand.options.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let item = activeCommand.options[section]

        if item is SelectCommand {
            return item.title
        } else if item is TextCommand {
            return item.title
        }

        return nil
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let item = activeCommand.options[section]

        if item.title.isEmpty {
            return 5
        } else {
            return 44
        }
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == tableView.numberOfSections - 1 {
            return 44
        } else {
            return .leastNonzeroMagnitude
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = activeCommand.options[section]

        if let select = item as? SelectCommand {
            return select.friendlyValues.count
        } else if item is CheckCommand {
            return 1
        } else if item is TextCommand {
            return 1
        } else {
            fatalError("Unknown command type")
        }
    }

    func cell(for command: CheckCommand, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Check", for: indexPath) as? CheckTableViewCell else {
            fatalError("Unable to dequeue a CheckTableViewCell.")
        }

        cell.textLabel?.text = command.title
        cell.toggle.isOn = command.value

        cell.switchChangedAction = { [weak command] value in
            command?.value = value
        }

        return cell
    }

    func cell(for command: TextCommand, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Text", for: indexPath) as? TextTableViewCell else {
            fatalError("Unable to dequeue TextTableViewCell.")
        }

        cell.textChangedAction = { [weak command] newText in
            command?.value = newText
        }

        if command.placeholder.isEmpty {
            cell.textField.placeholder = "Enter text"
        } else {
            cell.textField.placeholder = command.placeholder
        }

        cell.textField.text = command.value

        if command.isNumeric {
            cell.textField.keyboardType = .decimalPad
        } else {
            cell.textField.keyboardType = .default
        }

        return cell
    }

    func cell(for command: SelectCommand, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Select", for: indexPath)
        cell.textLabel?.text = command.friendlyValues[indexPath.row]

        if indexPath.row == command.value {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = activeCommand.options[indexPath.section]

        if let select = item as? SelectCommand {
            return cell(for: select, at: indexPath)
        } else if let check = item as? CheckCommand {
            return cell(for: check, at: indexPath)
        } else if let text = item as? TextCommand {
            return cell(for: text, at: indexPath)
        } else {
            fatalError("Unknown command type.")
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let selectCommand = activeCommand.options[indexPath.section] as? SelectCommand else {
            return
        }

        selectCommand.value = indexPath.row

        for cell in tableView.visibleCells {
            guard let cellIndexPath = tableView.indexPath(for: cell) else {
                return
            }

            guard indexPath.section == cellIndexPath.section else {
                continue
            }

            cell.accessoryType = .none
        }

        let selected = tableView.cellForRow(at: indexPath)
        selected?.accessoryType = .checkmark
    }
}
