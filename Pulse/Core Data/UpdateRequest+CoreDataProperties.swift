//
//  UpdateRequest+CoreDataProperties.swift
//  Pulse
//
//  Created by Mitchell Porter on 3/1/17.
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
    @NSManaged public var updatedAt: Date?
    @NSManaged public var receivers: NSSet?
    @NSManaged public var sender: User?
    @NSManaged public var task: Task?
    
    public var senderIsCurrentUser: Bool {
        return self.sender!.objectId == User.currentUserId()
    }

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
