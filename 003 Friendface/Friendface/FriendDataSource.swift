//
//  FriendDataSource.swift
//  Friendface
//
//  Created by Paul Hudson on 29/01/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class FriendDataSource: NSObject, UITableViewDataSource {
    var friends = [Friend]()
    var filteredFriends = [Friend]()
    var dataChanged: (() -> Void)?

    var filterText: String? {
        didSet {
            filteredFriends = friends.matching(filterText)
            dataChanged?()
        }
    }

    func fetch(_ urlString: String) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        let url = "https://www.hackingwithswift.com/samples/friendface.json"
        decoder.decode([Friend].self, fromURL: url) { friends in
            self.friends = friends
            self.filteredFriends = friends
            self.dataChanged?()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredFriends.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let friend = filteredFriends[indexPath.row]

        cell.textLabel?.text = friend.name
        cell.detailTextLabel?.text = friend.friendList
        return cell
    }
}
