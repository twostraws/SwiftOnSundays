//
//  MemoryDataSource.swift
//  Memorize
//
//  Created by Paul Hudson on 29/01/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class MemoryDataSource: NSObject, UITableViewDataSource {
    var items = [MemoryItem]()

    override init() {
        guard let url = Bundle.main.url(forResource: "MemoryItems", withExtension: "json") else {
            fatalError("Unable to find MemoryItems.json")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Unable to load MemoryItems.json")
        }

        let decoder = JSONDecoder()

        guard let savedItems = try? decoder.decode([MemoryItem].self, from: data) else {
            fatalError("Failed to decode MemoryItems.json")
        }

        items = savedItems
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.text

        return cell
    }

    func item(at index: Int) -> MemoryItem {
        return items[index]
    }
}
