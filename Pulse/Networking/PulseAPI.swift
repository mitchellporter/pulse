//
//  PulseAPI.swift
//  Pulse
//
//  Created by Mitchell Porter on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation

enum WeekDay {
    case monday
    case wednesday
    case friday
}

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

extension PulseAPI {
    static let apiProtocol = Bundle.main.infoDictionary!["API_PROTOCOL"] as! String
    static let apiVersion = Bundle.main.infoDictionary!["API_VERSION"] as! String
    static let baseURL = Bundle.main.infoDictionary!["API_BASE_URL"] as! String
}

enum PulseAPI {
    
    // Auth
    case login(emailAddress: String, password: String) //
    case signup(emailAddress: String, name: String, position: String) //
    
    // Feed
    case getTasksAssignedToUser(assigneeId: String, offset: Int) //
    case getTasksCreatedByUser(assignerId: String, offset: Int) //
    
    // Create task
    case createTask(title: String, items: [String], assignees: [String], dueDate: Date?, updateDay: WeekDay) //
    case editTask(params: [String: AnyObject]) //
    
    // Task Updates
    case getTask(taskId: String) //
    case requestTaskUpdate(taskId: String) //
    case sendTaskUpdate(taskId: String, completionPercentage: Float) //
    case finishTask(taskId: String) //
    
    // Task Items
    case finishTaskItem(taskId: String, itemId: String) //
    
    // Team members
    case getTeamMembers(teamId: String)
}

extension PulseAPI {
    var method: HTTPMethod {
        switch self {
            case .getTasksCreatedByUser,
                 .getTasksAssignedToUser,
                 .getTask,
                 .getTeamMembers:
            return .get
            
        case .editTask:
            return .put
        
        case .login,
             .signup,
             .createTask,
             .requestTaskUpdate,
             .sendTaskUpdate,
             .finishTask,
             .finishTaskItem:
            return .post
            
        default: return .get
        }
    }
}

extension PulseAPI {
    var path: String {
        switch self {
        case .login:
            return "/api/\(PulseAPI.apiVersion)/auth/signin"
        case .signup:
            return "/api/\(PulseAPI.apiVersion)/users"
        case .createTask:
            return "/api/\(PulseAPI.apiVersion)/tasks"
        case let .getTask(taskId):
            return "/api/\(PulseAPI.apiVersion)/tasks/\(taskId)"
        case .getTasksAssignedToUser:
            return "/api/\(PulseAPI.apiVersion)/tasks"
        case .getTasksCreatedByUser:
            return "/api/\(PulseAPI.apiVersion)/tasks/"
        case .createTask:
            return "/api/\(PulseAPI.apiVersion)/tasks/"
        case let .editTask(taskId):
            return "/api/\(PulseAPI.apiVersion)/tasks/\(taskId)"
        case let .finishTask(taskId):
            return "/api/\(PulseAPI.apiVersion)/tasks/\(taskId)"
        case let .requestTaskUpdate(taskId):
            return "/api/\(PulseAPI.apiVersion)/tasks/\(taskId)"
        case let .sendTaskUpdate(taskId):
            return "/api/\(PulseAPI.apiVersion)/tasks/\(taskId)"
        case let .finishTaskItem(taskId, itemId):
            return "/api/\(PulseAPI.apiVersion)/tasks/\(taskId)/items/\(itemId)"
        case let .getTeamMembers(teamId):
            return "/api/\(PulseAPI.apiVersion)/team/\(teamId)/members/"
        }
    }
}

extension PulseAPI {
    var url: URL? {
        return URL(string: PulseAPI.apiProtocol + PulseAPI.baseURL + self.path)
    }
}

extension PulseAPI {
    var requiresAuthToken: Bool {
        switch self {
        case .login,
             .signup:
            return false
        default:
            return true
        }
    }
}

extension PulseAPI {
    var parameters: [String: AnyHashable]? {
        switch self {
        case let .getTasksCreatedByUser(assignerId, offset):
            return [
                "assigner": assignerId,
                "offset": offset,
                "limit": 25
            ]
        case let .getTasksAssignedToUser(assigneeId, offset):
            return [
                "assignee": assigneeId,
                "offset": offset,
                "limit": 25
            ]
               default: return nil
        }
    }
}

extension PulseAPI {
    var headers: [String: String] {
        var assigned: [String: String] = ["Accept": "application/json", "Content-Type": "application/json"]
        if requiresAuthToken { assigned["Authorization"] = "586ecdc0213f22d94db5ef7f" } // TODO: Removed hardcoded id
        
        switch self {
        default: return assigned
        }
    }
}



