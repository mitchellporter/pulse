//
//  TaskService.swift
//  Pulse
//
//  Created by Mitchell Porter on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias TaskServiceSuccess = (_ task: Task) -> ()
typealias TasksServiceSuccess = (_ tasks: [Task]) -> ()
typealias MyTasksSuccess = () -> ()

struct TaskService {
    static func createTask(title: String, items: [String], assignees: [String]?, dueDate: Date?, updateDays: [WeekDay]?, success: @escaping TaskServiceSuccess, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .createTask(title: title, items: items, assignees: assignees, dueDate: dueDate, updateDays: updateDays), success: { (data) in
            let json = JSON(data: data)
            if json["success"].boolValue {
                if let taskJSON = json["task"].dictionaryObject {
                    let task = Task.from(json: taskJSON as [String : AnyObject], context: CoreDataStack.shared.context)
                    success(task)
                }
                
                // TODO: Remove task invitation parsing
                if let taskInvitationsJSON = json["task_invitations"].arrayObject {
                    var taskInvitations = [TaskInvitation]()
                    taskInvitationsJSON.forEach({ (taskInvitationJSON) in
                        let taskInvitation = TaskInvitation.from(json: taskInvitationJSON as! [String : AnyObject], context: CoreDataStack.shared.context)
                        taskInvitations.append(taskInvitation)
                    })
                }
            }
        }) { (error, statusCode) in
            failure(error, statusCode)
        }
    }
    
    static func finishTask(taskId: String, success: @escaping TaskServiceSuccess, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .finishTask(taskId: taskId), success: { (data) in
            let json = JSON(data: data)
            if json["success"].boolValue {
                if let taskJSON = json["task"].dictionaryObject {
                    let task = Task.from(json: taskJSON as [String : AnyObject], context: CoreDataStack.shared.context)
                    success(task)
                }
            }
        }, failure: failure)
    }
    
    static func getTasksCreatedByUser(assignerId: String, offset: Int, status: String? = nil, success: @escaping TasksServiceSuccess, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .getTasksCreatedByUser(assignerId: assignerId, offset: offset, status: status), success: { (data) in
            let json = JSON(data: data)
            if json["success"].boolValue {
                if let tasksJSON = json["tasks"].arrayObject {
                    var tasks = [Task]()
                    tasksJSON.forEach({ (taskJSON) in
                        let task = Task.from(json: taskJSON as! [String : AnyObject], context: CoreDataStack.shared.context)
                        tasks.append(task)
                    })
                    success(tasks)
                }
            }
        }) { (error, statusCode) in
            failure(error, statusCode)
        }
    }
    
    static func getTasksAssignedToUser(assigneeId: String, offset: Int, status: String? = nil, success: @escaping TasksServiceSuccess, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .getTasksAssignedToUser(assigneeId: assigneeId, offset: offset, status: status), success: { (data) in
            let json = JSON(data: data)
            if json["success"].boolValue {
                if let tasksJSON = json["tasks"].arrayObject {
                    var tasks = [Task]()
                    tasksJSON.forEach({ (taskJSON) in
                        let task = Task.from(json: taskJSON as! [String : AnyObject], context: CoreDataStack.shared.context)
                        tasks.append(task)
                    })
                   success(tasks)
                }
            }
        }) { (error, statusCode) in
            failure(error, statusCode)
        }
    }
    
    static func getTask(taskId: String, success: @escaping TaskServiceSuccess, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .getTask(taskId: taskId), success: { (data) in
            let json = JSON(data: data)
            if json["success"].boolValue {
                if let taskJSON = json["task"].dictionaryObject {
                    let task = Task.from(json: taskJSON as [String : AnyObject], context: CoreDataStack.shared.context)
                    success(task)
                }
            }
        }, failure: failure)
    }
    
    // TODO: Remove duplication from below functions
    
    // Experimental
    // TODO: Don't worry about returning data right now since we'll be accessing it via core data FRC's anyway
    static func getMyTasks(success: @escaping MyTasksSuccess, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .getMyTasks, success: { (data) in
            let json = JSON(data: data)
            if json["success"].boolValue {
                // Task Invitations
                if let taskInvitationsJSON = json["task_invitations"].arrayObject {
                    var taskInvitations = [TaskInvitation]()
                    taskInvitationsJSON.forEach({ (taskInvitationJSON) in
                        let taskInvitation = TaskInvitation.from(json: taskInvitationJSON as! [String : AnyObject], context: CoreDataStack.shared.context)
                        taskInvitations.append(taskInvitation)
                    })
                }
                // Tasks
                if let tasksJSON = json["tasks"].arrayObject {
                    var tasks = [Task]()
                    tasksJSON.forEach({ (taskJSON) in
                        let task = Task.from(json: taskJSON as! [String : AnyObject], context: CoreDataStack.shared.context)
                        tasks.append(task)
                    })
                }
                success()
            }
        }, failure: failure)
    }
    
    // Experimental
    // TODO: Don't worry about returning data right now since we'll be accessing it via core data FRC's anyway
    static func getTasksCreated(success: @escaping MyTasksSuccess, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .getTasksCreated, success: { (data) in
            let json = JSON(data: data)
            if json["success"].boolValue {
                // Task Invitations
                if let taskInvitationsJSON = json["task_invitations"].arrayObject {
                    var taskInvitations = [TaskInvitation]()
                    taskInvitationsJSON.forEach({ (taskInvitationJSON) in
                        let taskInvitation = TaskInvitation.from(json: taskInvitationJSON as! [String : AnyObject], context: CoreDataStack.shared.context)
                        taskInvitations.append(taskInvitation)
                    })
                }
                // Tasks
                if let tasksJSON = json["tasks"].arrayObject {
                    var tasks = [Task]()
                    tasksJSON.forEach({ (taskJSON) in
                        let task = Task.from(json: taskJSON as! [String : AnyObject], context: CoreDataStack.shared.context)
                        tasks.append(task)
                    })
                }
                success()
            }
        }, failure: failure)
    }
    
    static func markTaskItemInProgress(taskId: String, itemId: String, success: @escaping TaskServiceSuccess, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .markTaskItemInProgress(taskId: taskId, itemId: itemId), success: { (data) in
            let json = JSON(data: data)
            if json["success"].boolValue {
                if let taskJSON = json["task"].dictionaryObject {
                    let task = Task.from(json: taskJSON as [String : AnyObject], context: CoreDataStack.shared.context)
                    success(task)
                }
            }
        }, failure: failure)
    }
    
    static func markTaskItemCompleted(taskId: String, itemId: String, success: @escaping TaskServiceSuccess, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .markTaskItemCompleted(taskId: taskId, itemId: itemId), success: { (data) in
            let json = JSON(data: data)
            if json["success"].boolValue {
                if let taskJSON = json["task"].dictionaryObject {
                    let task = Task.from(json: taskJSON as [String : AnyObject], context: CoreDataStack.shared.context)
                    success(task)
                }
            }
        }, failure: failure)
    }
    
    static func addAssigneesToTask(taskId: String, assignees: [String], success: @escaping TaskServiceSuccess, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .addAssigneesToTask(taskId: taskId, assignees: assignees), success: { (data) in
            let json = JSON(data: data)
            if json["success"].boolValue {
                if let taskJSON = json["task"].dictionaryObject {
                    let task = Task.from(json: taskJSON as [String : AnyObject], context: CoreDataStack.shared.context)
                    success(task)
                }
            }
        }, failure: failure)
    }
    
    static func deleteTask(taskId: String, success: @escaping EmptySuccessCompletion, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .deleteTask(taskId: taskId), success: { (data) in
            let json = JSON(data: data)
            if json["success"].boolValue {
                success()
            }
        }, failure: failure)
    }
}
