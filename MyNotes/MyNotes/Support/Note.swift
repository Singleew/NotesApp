//
//  Note.swift
//  MyNotes
//
//  Created by ilia nikashov on 04.03.2022.
//

import CoreData

@objc(Note)
class Note: NSManagedObject {
    @NSManaged var id: NSNumber!
    @NSManaged var title: String!
    @NSManaged var descr: String!
    @NSManaged var deletedDate: Date?
}

