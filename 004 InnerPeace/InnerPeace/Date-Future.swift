//
//  Date-Future.swift
//  InnerPeace
//
//  Created by Paul Hudson on 03/02/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import Foundation

extension Date {
    func byAdding(days: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = days

        return Calendar.current.date(byAdding: dateComponents, to: self) ?? self
    }
}
