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
    
    func mostRecentUpdateResponse() -> Response? {
        return self.responsesSortedByRecency()?.first
    }
    
    func responsesSortedByRecency() -> [Response]? {
        guard let responses = self.responses else { return nil }
        return responses.sorted { $0.createdAt! > $1.createdAt! }
    }
    
}

extension User {
    static func currentUserId() -> String {
        let defaults = UserDefaults.standard
        var userId = defaults.object(forKey: "user_id") as? String
        if (userId == nil) {
            userId = "586ecdc0213f22d94db5ef7f"
        }
        return userId!
    }
    
    static func currentUser() -> User? {
        let token = AuthToken()
        guard let objectId = token.userId, let name = token.name, let email = token.email, let position = token.position else { return nil }
        
        let user = User(entity: NSEntityDescription.entity(forEntityName: "User", in: CoreDataStack.shared.context)!, insertInto: CoreDataStack.shared.context)
        user.objectId = objectId
        user.name = name
        user.email = email
        user.position = position
        return user
    }
    
    // TODO: Combine this with currentUser - shouldn't be separate
    static func currentUserTeamId() -> String? {
        return AuthToken().teamId
    }
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
        let objectId = json["_id"] as! String
        var createdAt: Date?
        var updatedAt: Date?
        if let createdAtTime = json["created_at"] as? String {
            createdAt = Date.from(createdAtTime)
        }
        if let updatedAtTime = json["updated_at"] as? String {
            updatedAt = Date.from(updatedAtTime)
        }
        
        let email = json["email"] as! String

        let name = json["name"] as! String
        let position = json["position"] as! String
        let avatarURL = json["avatar_url"] as? String
        
        let user = User(entity: NSEntityDescription.entity(forEntityName: "User", in: context)!, insertInto: context)
        user.objectId = objectId
        user.createdAt = createdAt
        user.updatedAt = updatedAt
        user.name = name
        user.position = position
        user.avatarURL = avatarURL
        user.email = email
        
        if let teamJSON = json["team"] as? [String: AnyObject] {
            let team = Team.from(json: teamJSON, context: context) as Team
            user.team = team
        }
        
        if let responseJSON = json["most_recent_update_response"] as? [String: AnyObject] {
            let response = Response.from(json: responseJSON, context: context) as Response
            user.addToResponses(response)
        }
        
        // TODO: No current use for both of these
        if let createdTasksJSON = json["created_tasks"] as? [[String: AnyObject]] {
            createdTasksJSON.forEach({ createdTaskJSON in
                let task = Task.from(json: createdTaskJSON, context: context) as Task
                user.addToCreatedTasks(task)
            })
        }
        
        if let assignedTasksJSON = json["received_tasks"] as? [[String: AnyObject]] {
            assignedTasksJSON.forEach({ assignedTaskJSON in
                let task = Task.from(json: assignedTaskJSON, context: context) as Task
                user.addToReceivedTasks(task)
            })
        }
        
        if let sentTaskInvitationsJSON = json["sent_task_invitations"] as? [[String: AnyObject]] {
            sentTaskInvitationsJSON.forEach({ sentTaskInvitationJSON in
                let taskInvitation = TaskInvitation.from(json: sentTaskInvitationJSON, context: context) as TaskInvitation
                user.addToSentTaskInvitations(taskInvitation)
            })
        }
        
        if let receivedTaskInvitationsJSON = json["received_task_invitations"] as? [[String: AnyObject]] {
            receivedTaskInvitationsJSON.forEach({ receivedTaskInvitationJSON in
                let taskInvitation = TaskInvitation.from(json: receivedTaskInvitationJSON, context: context) as TaskInvitation
                user.addToReceivedTaskInvitations(taskInvitation)
            })
        }
        
        if let invitesJSON = json["invites"] as? [[String: AnyObject]] {
            invitesJSON.forEach({ inviteJSON in
                let invite = Invite.from(json: inviteJSON, context: context)
                user.addToSentInvites(invite)
            })
        }
        
        return user
    }
}
