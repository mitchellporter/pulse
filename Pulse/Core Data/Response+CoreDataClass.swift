//
//  Response+CoreDataClass.swift
//  Pulse
//
//  Created by Mitchell Porter on 3/16/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

@objc(Response)
public class Response: NSManagedObject {

}

enum ResponseStatus: String {
    case requested
    case sent
}

extension Response {
    var responseStatus: ResponseStatus {
        return ResponseStatus(rawValue: self.status)!
    }
}

extension Response: PulseType {
    typealias T = Response
    
    static func createFetchRequest<T>() -> NSFetchRequest<T> {
        return NSFetchRequest(entityName: "Response")
    }
    
    func toJSON() -> [String : AnyObject] {
        return [String: AnyObject]()
    }
    
    static func from(json: [String : AnyObject], context: NSManagedObjectContext) -> Response {
        let objectId = json["_id"] as! String
        
        var createdAt: Date?
        var updatedAt: Date?
        if let createdAtTime = json["created_at"] as? String {
            createdAt = Date.from(createdAtTime)
        }
        if let updatedAtTime = json["updated_at"] as? String {
            updatedAt = Date.from(updatedAtTime)
        }
        
        let status = json["status"] as! String
        let completionPercentage = json["completion_percentage"] as! Float
            
        let description = NSEntityDescription.entity(forEntityName: "Response", in: context)!
        let response = Response(entity: description, insertInto: context)
        response.objectId = objectId
        response.createdAt = createdAt
        response.updatedAt = updatedAt
        response.status = status
        response.completionPercentage = completionPercentage
        
        print(status)
        
        if let updateJSON = json["update"] as? [String: AnyObject] {
            let update = Update.from(json: updateJSON, context: context)
            response.update = update
        }
        
        if let assigneeJSON = json["assignee"] as? [String: AnyObject] {
            let assignee = User.from(json: assigneeJSON, context: context)
            response.assignee = assignee
        }
        return response
    }
}
