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
    
    static func signin(teamId: String, email: String, password: String, success: @escaping UserSuccessCompletion, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .signin(teamId: teamId, email: email, password: password), success: { (data) in
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
    static func signupAndCreateTeam(teamName: String, email: String, password: String, fullName: String, position: String, success: @escaping UserSuccessCompletion, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .signupAndCreateTeam(teamName: teamName, email: email, password: password, fullName: fullName, position: position), success: { (data) in
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
    static func signupToExistingTeam(teamId: String, email: String, password: String, fullName: String, position: String, success: @escaping UserSuccessCompletion, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .signupToExistingTeam(teamId: teamId, email: email, password: password, fullName: fullName, position: position), success: { (data) in
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
