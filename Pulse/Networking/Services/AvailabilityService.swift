//
//  AvailabilityService.swift
//  Pulse
//
//  Created by Mitchell Porter on 3/22/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AvailabilityService {
    static func checkTeamAvailability(teamName: String, success: @escaping (_ teamName: String) -> Void, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .checkTeamNameAvailability(teamName: teamName), success: { (data) in
            let json = JSON(data: data)
            if json["success"].boolValue {
                if let teamName = json["team_name"].string {
                    success(teamName)
                }
            }
        }, failure: failure)
    }
    
    static func checkEmailAvailability(email: String, success: @escaping (_ email: String) -> Void, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .checkEmailAvailability(email: email), success: { (data) in
            let json = JSON(data: data)
            if json["success"].boolValue {
                if let email = json["email"].string {
                    success(email)
                }
            }
        }, failure: failure)
    }
}
