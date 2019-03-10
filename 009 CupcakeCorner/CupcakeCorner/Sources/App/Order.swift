//
//  Order.swift
//  App
//
//  Created by Paul Hudson on 10/03/2019.
//

import FluentSQLite
import Foundation
import Vapor

struct Order: Content, SQLiteModel, Migration {
    var id: Int?
    var cakeName: String
    var buyerName: String
    var date: Date?
}
