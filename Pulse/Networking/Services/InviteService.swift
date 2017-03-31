//
//  InviteService.swift
//  Pulse
//
//  Created by Mitchell Porter on 3/30/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

struct InviteService {
    static func inviteContactsToTask(taskId: String, contacts: [[String: AnyObject]], success: @escaping (_ invites: [Invite]) -> Void, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .inviteContactsToTask(taskId: taskId, contacts: contacts), success: { (data) in
            let json = JSON(data: data)
            if json["success"].boolValue {
                if let invitesJSON = json["invites"].arrayObject {
                    var invites = [Invite]()
                    invitesJSON.forEach({ (inviteJSON) in
                        let invite = Invite.from(json: inviteJSON as! [String : AnyObject], context: CoreDataStack.shared.context)
                        invites.append(invite)
                    })
                    success(invites)
                }
            }
        }, failure: failure)
    }
}
