//
//  Joke+CoreDataProperties.swift
//  DadJokes
//
//  Created by Paul Hudson on 22/09/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//
//

import Foundation
import CoreData


extension Joke {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Joke> {
        return NSFetchRequest<Joke>(entityName: "Joke")
    }

    @NSManaged public var setup: String
    @NSManaged public var punchline: String
    @NSManaged public var rating: String

}
