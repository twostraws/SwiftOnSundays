//
//  Bundle-WordLoading.swift
//  Switcharoo
//
//  Created by Paul Hudson on 27/10/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import Foundation

extension Bundle {
    func words(from filename: String) -> Set<String> {
        guard let fileURL = url(forResource: filename, withExtension: nil) else {
            fatalError("Can't find \(filename)")
        }

        guard let contents = try? String(contentsOf: fileURL) else {
            fatalError("Can't load \(filename)")
        }

        return Set(contents.components(separatedBy: "\n"))
    }
}
