//
//  FileManager-DocumentsDirectory.swift
//  WatchReactions WatchKit Extension
//
//  Created by Paul Hudson on 05/05/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import Foundation

extension FileManager {
    func getDocumentsDirectory() -> URL {
        let paths = urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
