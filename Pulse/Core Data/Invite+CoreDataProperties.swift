//
//  Invite+CoreDataProperties.swift
//  Pulse
//
//  Created by Mitchell Porter on 3/30/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import CoreData


extension Invite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Invite> {
        return NSFetchRequest<Invite>(entityName: "Invite");
    }

    @NSManaged public var objectId: String
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var type: String?
    @NSManaged public var status: String?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var team: Team?
    @NSManaged public var task: Task?
    @NSManaged public var sender: User?

}
