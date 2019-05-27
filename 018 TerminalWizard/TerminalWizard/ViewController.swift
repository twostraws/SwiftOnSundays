//
//  ViewController.swift
//  TerminalWizard
//
//  Created by Paul Hudson on 26/05/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var output: UILabel!
    var commands = [Command]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addCommand))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        writeOutput()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commands.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let cmd = commands[indexPath.row]

        cell.textLabel?.text = cmd.friendlyName
        cell.detailTextLabel?.text = cmd.summary

        if cmd.mustBeFirst {
            cell.textLabel?.textColor = .blue
        } else {
            cell.textLabel?.textColor = nil
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let command = commands[indexPath.row]

        if !command.options.isEmpty {
            let vc = EditCommandViewController(style: .grouped)
            vc.activeCommand = command
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    @objc func addCommand() {
        let vc = ChooseCommandViewController(style: .plain)
        vc.commandController = self
        navigationController?.pushViewController(vc, animated: true)
    }

    func commandAdded(_ command: Command) {
        commands.append(command)
    }

    func writeOutput() {
        var str = ""

        for command in commands {
            let output = command.writeOutput()

            if !output.isEmpty {
                if !str.isEmpty {
                    str = str.trimmingCharacters(in: .whitespacesAndNewlines)
                    str += " | "
                }

                str.append(output)
            }
        }

        let cmd = str.trimmingCharacters(in: .whitespacesAndNewlines)

        if cmd.isEmpty {
            output.text = "Tap + to get started"
        } else {
            output.text = cmd
        }
    }
}

