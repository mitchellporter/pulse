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
    @NSManaged public var receiver: User?
    @NSManaged public var sender: User?
    @NSManaged public var task: Task?
    @NSManaged public var update: Update?
    @NSManaged public var status: String

}
