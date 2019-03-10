//
//  Cupcake.swift
//  App
//
//  Created by Paul Hudson on 10/03/2019.
//

import FluentSQLite
import Foundation
import Vapor

struct Cupcake: Content, SQLiteModel, Migration {
    var id: Int?
    var name: String
    var description: String
    var price: Int
}
