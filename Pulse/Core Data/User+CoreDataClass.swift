//
//  User+CoreDataClass.swift
//  Pulse
//
//  Created by Mitchell Porter on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {

}

extension User: PulseType {
    typealias T = User
    
    static func createFetchRequest<T>() -> NSFetchRequest<T> {
        return NSFetchRequest(entityName: "User")
    }
    
    // TODO: Implement
    func toJSON() -> [String : AnyObject] {
        return [String: AnyObject]()
    }
    
    // TODO: Implement
    static func from(json: [String : AnyObject], context: NSManagedObjectContext) -> User {
        let description = NSEntityDescription.entity(forEntityName: "User", in: context)!
        return User(entity: description, insertInto: context)
    }
}
