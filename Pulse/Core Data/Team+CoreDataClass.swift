//
//  Team+CoreDataClass.swift
//  Pulse
//
//  Created by Mitchell Porter on 2/24/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import CoreData

@objc(Team)
public class Team: NSManagedObject {

}

extension Team: PulseType {
    typealias T = Team
    
    static func createFetchRequest<T>() -> NSFetchRequest<T> {
        return NSFetchRequest(entityName: "Team")
    }
    
    // TODO: Implement
    func toJSON() -> [String : AnyObject] {
        return [String: AnyObject]()
    }
    
    // TODO: Implement
    static func from(json: [String : AnyObject], context: NSManagedObjectContext) -> Team {
        
        let objectId = json["_id"] as! String
        
        var createdAt: Date?
        var updatedAt: Date?
        if let createdAtTime = json["created_at"] as? String {
            createdAt = Date.from(createdAtTime)
        }
        if let updatedAtTime = json["updated_at"] as? String {
            updatedAt = Date.from(updatedAtTime)
        }
        
        let domain = json["domain"] as! String
        
        let description = NSEntityDescription.entity(forEntityName: "Team", in: context)!
        let team = Team(entity: description, insertInto: context)
        team.objectId = objectId
        team.createdAt = createdAt
        team.updatedAt = updatedAt
        team.domain = domain
        
        return team
    }
}
