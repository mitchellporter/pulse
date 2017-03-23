//
//  UserService.swift
//  Pulse
//
//  Created by Mitchell Porter on 3/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias UserSuccessCompletion = (_ user: User) -> Void

struct UserService {
    
    // Parse team separately? - probably not
    // TODO: Parse token
    static func signupAndCreateTeam(teamName: String, username: String, emailAddress: String, password: String, fullName: String? = nil, position: String? = nil, success: @escaping UserSuccessCompletion, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .signupAndCreateTeam(teamName: teamName, username: username, emailAddress: emailAddress, password: password, fullName: fullName, position: position), success: { (data) in
            let json = JSON(data: data)
            if json["success"].boolValue {
                if let userJSON = json["user"].dictionaryObject {
                    let user = User.from(json: userJSON as [String : AnyObject], context: CoreDataStack.shared.context)
                    success(user)
                }
            }
        }, failure: failure)
    }
    
    // Parse team separately? - probably not
    // TODO: Parse token
    static func signupToExistingTeam(teamId: String, username: String, emailAddress: String, password: String, fullName: String? = nil, position: String? = nil, success: @escaping UserSuccessCompletion, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .signupToExistingTeam(teamId: teamId, username: username, emailAddress: emailAddress, password: password, fullName: fullName, position: position), success: { (data) in
            let json = JSON(data: data)
            if json["success"].boolValue {
                if let userJSON = json["user"].dictionaryObject {
                    let user = User.from(json: userJSON as [String : AnyObject], context: CoreDataStack.shared.context)
                    success(user)
                }
            }
        }, failure: failure)
    }
}
