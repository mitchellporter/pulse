//
//  Task+CoreDataProperties.swift
//  Pulse
//
//  Created by Mitchell Porter on 3/7/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task");
    }

    @NSManaged public var completionPercentage: Float
    @NSManaged public var createdAt: Date?
    @NSManaged public var dueDate: Date?
    @NSManaged public var objectId: String
    @NSManaged public var status: String
    @NSManaged public var title: String
    @NSManaged public var update_day: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var assignees: NSSet?
    @NSManaged public var assigner: User?
    @NSManaged public var invitations: NSSet?
    @NSManaged public var items: NSSet?
    @NSManaged public var updateRequests: NSSet?
    @NSManaged public var updates: NSSet?

}

// MARK: Generated accessors for assignees
extension Task {

    @objc(addAssigneesObject:)
    @NSManaged public func addToAssignees(_ value: User)

    @objc(removeAssigneesObject:)
    @NSManaged public func removeFromAssignees(_ value: User)

    @objc(addAssignees:)
    @NSManaged public func addToAssignees(_ values: NSSet)

    @objc(removeAssignees:)
    @NSManaged public func removeFromAssignees(_ values: NSSet)

}

// MARK: Generated accessors for invitations
extension Task {

    @objc(addInvitationsObject:)
    @NSManaged public func addToInvitations(_ value: TaskInvitation)

    @objc(removeInvitationsObject:)
    @NSManaged public func removeFromInvitations(_ value: TaskInvitation)

    @objc(addInvitations:)
    @NSManaged public func addToInvitations(_ values: NSSet)

    @objc(removeInvitations:)
    @NSManaged public func removeFromInvitations(_ values: NSSet)

}

// MARK: Generated accessors for items
extension Task {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

// MARK: Generated accessors for updateRequests
extension Task {

    @objc(addUpdateRequestsObject:)
    @NSManaged public func addToUpdateRequests(_ value: UpdateRequest)

    @objc(removeUpdateRequestsObject:)
    @NSManaged public func removeFromUpdateRequests(_ value: UpdateRequest)

    @objc(addUpdateRequests:)
    @NSManaged public func addToUpdateRequests(_ values: NSSet)

    @objc(removeUpdateRequests:)
    @NSManaged public func removeFromUpdateRequests(_ values: NSSet)

}

// MARK: Generated accessors for updates
extension Task {

    @objc(addUpdatesObject:)
    @NSManaged public func addToUpdates(_ value: Update)

    @objc(removeUpdatesObject:)
    @NSManaged public func removeFromUpdates(_ value: Update)

    @objc(addUpdates:)
    @NSManaged public func addToUpdates(_ values: NSSet)

    @objc(removeUpdates:)
    @NSManaged public func removeFromUpdates(_ values: NSSet)

}
