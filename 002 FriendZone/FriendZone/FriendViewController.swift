//
//  FriendViewController.swift
//  FriendZone
//
//  Created by Paul Hudson on 29/01/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class FriendViewController: UITableViewController, Storyboarded {
    weak var coordinator: MainCoordinator?
    var friend: Friend!

    var timeZones = [TimeZone]()
    var selectedTimeZone = 0

    var nameEditingCell: TextTableViewCell? {
        let indexPath = IndexPath(row: 0, section: 0)
        return tableView.cellForRow(at: indexPath) as? TextTableViewCell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let identifiers = TimeZone.knownTimeZoneIdentifiers

        for identifier in identifiers {
            if let timeZone = TimeZone(identifier: identifier) {
                timeZones.append(timeZone)
            }
        }

        let now = Date()

        timeZones.sort {
            let ourDifference = $0.secondsFromGMT(for: now)
            let otherDifference = $1.secondsFromGMT(for: now)

            if ourDifference == otherDifference {
                return $0.identifier < $1.identifier
            } else {
                return ourDifference < otherDifference
            }
        }

        selectedTimeZone = timeZones.firstIndex(of: friend.timeZone) ?? 0
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coordinator?.update(friend: friend)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return timeZones.count
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Name your friend"
        } else {
            return "Select their timezone"
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "Name", for: indexPath) as? TextTableViewCell else {
                fatalError("Couldn't get a text table view cell.")
            }

            cell.textField?.text = friend.name
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeZone", for: indexPath)
            let timeZone = timeZones[indexPath.row]

            cell.textLabel?.text = timeZone.identifier.replacingOccurrences(of: "_", with: " ")

            let timeDifference = timeZone.secondsFromGMT(for: Date())
            cell.detailTextLabel?.text = timeDifference.timeString()

            if indexPath.row == selectedTimeZone {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }

            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            startEditingName()
        } else {
            selectRow(at: indexPath)
        }
    }

    @IBAction func nameChanged(_ sender: UITextField) {
        friend.name = sender.text ?? ""
    }

    func startEditingName() {
        nameEditingCell?.textField.becomeFirstResponder()
    }

    func selectRow(at indexPath: IndexPath) {
        nameEditingCell?.textField.resignFirstResponder()

        for cell in tableView.visibleCells {
            cell.accessoryType = .none
        }

        selectedTimeZone = indexPath.row
        friend.timeZone = timeZones[indexPath.row]
        let selected = tableView.cellForRow(at: indexPath)
        selected?.accessoryType = .checkmark

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
