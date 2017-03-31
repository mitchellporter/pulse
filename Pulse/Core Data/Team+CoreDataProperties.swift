//
//  Team+CoreDataProperties.swift
//  Pulse
//
//  Created by Mitchell Porter on 3/1/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import CoreData


extension Team {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Team> {
        return NSFetchRequest<Team>(entityName: "Team");
    }

    @NSManaged public var objectId: String
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var name: String
    @NSManaged public var members: NSSet?
    @NSManaged public var invites: Set<Invite>?
}

// MARK: Generated accessors for members
extension Team {

    @objc(addMembersObject:)
    @NSManaged public func addToMembers(_ value: User)

    @objc(removeMembersObject:)
    @NSManaged public func removeFromMembers(_ value: User)

    @objc(addMembers:)
    @NSManaged public func addToMembers(_ values: NSSet)

    @objc(removeMembers:)
    @NSManaged public func removeFromMembers(_ values: NSSet)

}

// MARK: Generated accessors for invites
extension Team {
    
    @objc(addInvitesObject:)
    @NSManaged public func addToInvites(_ value: Invite)
    
    @objc(removeInvitesObject:)
    @NSManaged public func removeFromInvites(_ value: Invite)
    
    @objc(addInvites:)
    @NSManaged public func addToInvites(_ values: NSSet)
    
    @objc(removeInvites:)
    @NSManaged public func removeFromInvites(_ values: NSSet)
    
}
