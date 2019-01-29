//
//  ViewController.swift
//  FriendZone
//
//  Created by Paul Hudson on 29/01/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, Storyboarded {
    weak var coordinator: MainCoordinator?

    var friends = [Friend]()
    var selectedFriend = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()

        title = "Friend Zone"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFriend))
    }

    func loadData() {
        let defaults = UserDefaults.standard

        guard let savedData = defaults.data(forKey: "Friends") else {
            return
        }

        let decoder = JSONDecoder()

        guard let savedFriends = try? decoder.decode([Friend].self, from: savedData) else {
            return
        }

        friends = savedFriends
    }

    func saveData() {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()

        guard let savedData = try? encoder.encode(friends) else {
            fatalError("Unable to encode friends data.")
        }

        defaults.set(savedData, forKey: "Friends")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let friend = friends[indexPath.row]
        cell.textLabel?.text = friend.name

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = friend.timeZone
        dateFormatter.timeStyle = .short

        cell.detailTextLabel?.text = dateFormatter.string(from: Date())

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFriend = indexPath.row
        coordinator?.configure(friend: friends[indexPath.row])
    }

    @objc func addFriend() {
        let friend = Friend()
        friends.append(friend)
        tableView.insertRows(at: [IndexPath(row: friends.count - 1, section: 0)], with: .automatic)
        saveData()

        selectedFriend = friends.count - 1
        coordinator?.configure(friend: friend)
    }

    func update(friend: Friend) {
        guard selectedFriend >= 0 else { return }

        tableView.reloadData()
        friends[selectedFriend] = friend
        saveData()
    }

}

