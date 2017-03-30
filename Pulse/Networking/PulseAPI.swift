//
//  PulseAPI.swift
//  Pulse
//
//  Created by Mitchell Porter on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation

enum WeekDay: String {
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
    case login(email: String, password: String) //
    case signup(email: String, name: String, position: String) //
    
    // TODO: Can only singup to an existing team right now
    case signupToExistingTeam(teamId: String, username: String, email: String, password: String, fullName: String, position: String) //
    case signupAndCreateTeam(teamName: String, username: String, email: String, password: String, fullName: String, position: String) //
    
    // Feed
    case getTasksAssignedToUser(assigneeId: String, offset: Int, status: String?) //
    case getTasksCreatedByUser(assignerId: String, offset: Int, status: String?) //
    
    // Create task
    case createTask(title: String, items: [String], assignees: [String], dueDate: Date?, updateDays: [WeekDay]?) //
    case editTask(params: [String: AnyObject]) //
    
    // Task Updates
    case getTask(taskId: String) //
    case requestTaskUpdate(taskId: String) //
    case sendTaskUpdate(taskId: String, completionPercentage: Float, message: String?) //
    case finishTask(taskId: String) //
    case respondToUpdateRequest(updateId: String, completionPercentage: Float, message: String?)
    case resendUpdateRequest(updateId: String, responseId: String)
    
    // Task Items
    case markTaskItemCompleted(taskId: String, itemId: String) //
    case markTaskItemInProgress(taskId: String, itemId: String)
    
    // Team members
    case getTeamMembers(teamId: String, offset: Int)
    
    // Experimental
    case getMyTasks
    case getTasksCreated
    case getUpdatesFeed
    
    // Task invitations
    case respondToTaskInvitation(taskInvitationId: String, status: TaskInvitationStatus)
    
    // Availability
    case checkTeamNameAvailability(teamName: String)
    case checkUsernameAvailability(username: String)
    case checkEmailAvailability(email: String)
    
    // Invites
    case inviteContactsToTask(taskId: String, contacts: [[String: AnyObject]])
    
}

extension PulseAPI {
    var method: HTTPMethod {
        switch self {
            case .getTasksCreatedByUser,
                 .getTasksAssignedToUser,
                 .getTask,
                 .getTeamMembers,
                 .getMyTasks,
                 .getTasksCreated,
                 .getUpdatesFeed,
                 .checkTeamNameAvailability,
                 .checkUsernameAvailability,
                 .checkEmailAvailability:
            return .get
            
        case .editTask,
             .respondToTaskInvitation,
             .finishTask,
             .markTaskItemInProgress,
             .respondToUpdateRequest,
             .markTaskItemCompleted:
            return .put
        
        case .login,
             .signup,
             .createTask,
             .requestTaskUpdate,
             .sendTaskUpdate,
             .resendUpdateRequest:
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
            return "/api/\(PulseAPI.apiVersion)/tasks"
        case let .editTask(taskId):
            return "/api/\(PulseAPI.apiVersion)/tasks/\(taskId)"
        case let .finishTask(taskId):
            return "/api/\(PulseAPI.apiVersion)/tasks/\(taskId)"
        case let .requestTaskUpdate(taskId):
            return "/api/\(PulseAPI.apiVersion)/tasks/\(taskId)/updates"
        case let .sendTaskUpdate(taskId, _, _):
            return "/api/\(PulseAPI.apiVersion)/tasks/\(taskId)/updates"
        case let .respondToUpdateRequest(updateId, _, _):
            return "/api/\(PulseAPI.apiVersion)/updates/\(updateId)"
        case let .resendUpdateRequest(updateId, responseId):
            return "/api/\(PulseAPI.apiVersion)/updates/\(updateId)/responses/\(responseId)/resend"
        case let .getTeamMembers(teamId, _):
            return "/api/\(PulseAPI.apiVersion)/teams/\(teamId)/members/"
        case .getMyTasks:
            return "/api/\(PulseAPI.apiVersion)/feeds/my_tasks"
        case .getTasksCreated:
            return "/api/\(PulseAPI.apiVersion)/feeds/tasks_created"
        case .getUpdatesFeed:
            return "/api/\(PulseAPI.apiVersion)/feeds/updates"
        case let .respondToTaskInvitation(taskInvitationId, _):
            return "/api/\(PulseAPI.apiVersion)/task_invitations/\(taskInvitationId)"
        case let .markTaskItemInProgress(taskId, itemId):
            return "/api/\(PulseAPI.apiVersion)/tasks/\(taskId)/items/\(itemId)"
        case let .markTaskItemCompleted(taskId, itemId):
            return "/api/\(PulseAPI.apiVersion)/tasks/\(taskId)/items/\(itemId)"
        case .checkTeamNameAvailability:
            return "/api/\(PulseAPI.apiVersion)/availability/teams"
        case .checkUsernameAvailability:
            return "/api/\(PulseAPI.apiVersion)/availability/usernames"
        case .checkEmailAvailability:
            return "/api/\(PulseAPI.apiVersion)/availability/emails"
        case let .inviteContactsToTask(taskId, _):
            return "/api/\(PulseAPI.apiVersion)/tasks/\(taskId)/invites"
            
            // TODO: Add signup cases
        default: return ""
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
    var parameters: [String: AnyObject]? {
        switch self {
            
        case let .signupAndCreateTeam(teamName, username, email, password, fullName, position):
            var params = [
                "team_name": teamName as AnyObject,
                "username": username as AnyObject,
                "email": email as AnyObject,
                "password": password as AnyObject
            ]
            params["name"] = fullName as AnyObject
            params["position"] = position as AnyObject
            return params
        case let .signupToExistingTeam(_, username, email, password, fullName, position):
            var params = [
                "username": username as AnyObject,
                "email": email as AnyObject,
                "password": password as AnyObject
            ]
            params["name"] = fullName as AnyObject
            params["position"] = position as AnyObject
            return params
        case let .getTasksCreatedByUser(assignerId, offset, status):
            var params =  [
                "assigner": assignerId as AnyObject,
                "offset": offset as AnyObject,
                "limit": 25 as AnyObject
            ]
            guard let status = status else { return params }
            params["status"] = status as AnyObject
            return params
        case let .getTasksAssignedToUser(assigneeId, offset, status):
            var params =  [
                "assignee": assigneeId as AnyObject,
                "offset": offset as AnyObject,
                "limit": 25 as AnyObject
            ]
            guard let status = status else { return params }
            params["status"] = status as AnyObject
            return params
        case let .createTask(title, items, assignees, dueDate, updateDays):
            var params = [
                "title": title as AnyObject,
                "items": items as AnyObject,
                "assignees": assignees as AnyObject
            ] as [String : AnyObject]
            if let dueDate = dueDate {
                params["due_date"] = dueDate.timeIntervalSince1970 as AnyObject
            }
            if let updateDays = updateDays {
                params["update_days"] = updateDays.flatMap { return $0.rawValue } as AnyObject
            }
            return params as [String : AnyObject]
        case let .getTeamMembers(_, offset):
            return [
                "offset": offset as AnyObject,
                "limit": 25 as AnyObject
            ]
        case .requestTaskUpdate:
            return [
                "type": "requested" as AnyObject
            ]
        case let .respondToUpdateRequest(_, completionPercentage, message):
            var params = [String: AnyObject]()
            params["completion_percentage"] = completionPercentage as AnyObject
            
            guard let message = message else { return params }
            params["message"] = message as AnyObject
            return params
        case let .respondToTaskInvitation(_, status):
            return [
                "status": status.rawValue as AnyObject
            ]
        case .finishTask:
            return [
                "status": "completed" as AnyObject
            ]
        case let .sendTaskUpdate(_, completionPercentage, message):
            var params = [String: AnyObject]()
            params["completion_percentage"] = completionPercentage as AnyObject
            params["type"] = "random" as AnyObject
            guard let message = message else { return params }
            params["message"] = message as AnyObject
            return params
        case .markTaskItemInProgress:
            return [
                "status": "in_progress" as AnyObject
            ]
        case .markTaskItemCompleted:
            return [
                "status": "completed" as AnyObject
            ]
        case let .checkTeamNameAvailability(teamName):
            return [
                "name": teamName as AnyObject
            ]
        case let .checkUsernameAvailability(username):
            return [
                "username": username as AnyObject
            ]
        case let .checkEmailAvailability(email):
            return [
                "email": email as AnyObject
            ]
        case let .inviteContactsToTask(_, contacts):
            return [
                "contacts": contacts as AnyObject
            ]
               default: return nil
        }
    }
}

extension PulseAPI {
    var headers: [String: String] {
        var assigned: [String: String] = ["Accept": "application/json", "Content-Type": "application/json"]
       
        if requiresAuthToken {
            assigned["Authorization"] = UserDefaults.standard.object(forKey: "bearer_token") as? String
        } // TODO: Removed hardcoded JWT
        
        switch self {
        default: return assigned
        }
    }
}



