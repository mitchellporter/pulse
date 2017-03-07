//
//  UpdateRequest+CoreDataProperties.swift
//  Pulse
//
//  Created by Mitchell Porter on 3/7/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import CoreData


extension UpdateRequest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UpdateRequest> {
        return NSFetchRequest<UpdateRequest>(entityName: "UpdateRequest");
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var objectId: String
    @NSManaged public var senderIsCurrentUser: Bool
    @NSManaged public var updatedAt: Date?
    @NSManaged public var receivers: NSSet?
    @NSManaged public var sender: User?
    @NSManaged public var task: Task?
    @NSManaged public var updates: NSSet?

}

// MARK: Generated accessors for receivers
extension UpdateRequest {

    @objc(addReceiversObject:)
    @NSManaged public func addToReceivers(_ value: User)

    @objc(removeReceiversObject:)
    @NSManaged public func removeFromReceivers(_ value: User)

    @objc(addReceivers:)
    @NSManaged public func addToReceivers(_ values: NSSet)

    @objc(removeReceivers:)
    @NSManaged public func removeFromReceivers(_ values: NSSet)

}

// MARK: Generated accessors for updates
extension UpdateRequest {

    @objc(addUpdatesObject:)
    @NSManaged public func addToUpdates(_ value: Update)

    @objc(removeUpdatesObject:)
    @NSManaged public func removeFromUpdates(_ value: Update)

    @objc(addUpdates:)
    @NSManaged public func addToUpdates(_ values: NSSet)

    @objc(removeUpdates:)
    @NSManaged public func removeFromUpdates(_ values: NSSet)

}
