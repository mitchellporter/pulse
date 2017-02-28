//
//  Update+CoreDataProperties.swift
//  Pulse
//
//  Created by Mitchell Porter on 2/28/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import CoreData


extension Update {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Update> {
        return NSFetchRequest<Update>(entityName: "Update");
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var objectId: String
    @NSManaged public var updatedAt: Date?
    @NSManaged public var receivers: NSSet?
    @NSManaged public var sender: User?
    @NSManaged public var task: Task?

}

// MARK: Generated accessors for receivers
extension Update {

    @objc(addReceiversObject:)
    @NSManaged public func addToReceivers(_ value: User)

    @objc(removeReceiversObject:)
    @NSManaged public func removeFromReceivers(_ value: User)

    @objc(addReceivers:)
    @NSManaged public func addToReceivers(_ values: NSSet)

    @objc(removeReceivers:)
    @NSManaged public func removeFromReceivers(_ values: NSSet)

}
