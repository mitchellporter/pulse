//
//  TeamService.swift
//  Pulse
//
//  Created by Mitchell Porter on 2/24/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias UsersSuccessCompletion = (_ users: [User]) -> Void

struct TeamService {
    static func getTeamMembers(teamId: String, success: @escaping UsersSuccessCompletion, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .getTeamMembers(teamId: teamId), success: { (data) in
            let json = JSON(data: data)
            if json["success"].boolValue {
                if let usersJSON = json["team_members"].arrayObject {
                    var teamMembers = [User]()
                    usersJSON.forEach({ (userJSON) in
                        let user = User.from(json: userJSON as! [String : AnyObject], context: CoreDataStack.shared.context)
                        teamMembers.append(user)
                    })
                    success(teamMembers)
                }
            }
        }) { (error, statusCode) in
            failure(error, statusCode)
        }
    }
}
