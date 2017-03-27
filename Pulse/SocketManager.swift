//
//  SocketManager.swift
//  Ginger
//
//  Created by Mitchell Porter on 1/13/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import PubNub
import CoreData

enum UpdateType: String {
    case newMessage = "new_message"
}

class SocketManager: NSObject {
    static let sharedManager = SocketManager()
    private var pubnub: PubNub?
    private let publishKey = "pub-c-874ce7f4-a1ce-4e25-bbc5-c3fb8e4c1a24"
    private let subscribeKey = "sub-c-007d8d40-d9fc-11e6-b6b1-02ee2ddab7fe"
    private let testSubChannel = "nodejs_channel" // messages coming from API
    private let testPubChannel = "ios_channel" // messages sent to the API - with permissions working this should NEVER work
    
    private override init() {
        super.init()
        // Setup
    }
    
    init(user: User) {
        super.init()
        self.setup()
    }
    
    private func setup() {
    }
    
    func connect(userId: String) {
        let config = PNConfiguration(publishKey: self.publishKey, subscribeKey: self.subscribeKey)
        config.uuid = userId // TODO: I feel like both uuid and authKey should be set to user's objectId
        config.authKey = userId // ????
        config.presenceHeartbeatInterval = 20
        config.presenceHeartbeatValue = 60
        
        self.pubnub = PubNub.clientWithConfiguration(config)
        self.pubnub?.logger.setLogLevel(0)
        self.pubnub?.addListener(self)
        
        let rooms = [self.testSubChannel, "hello_world", userId]
        self.pubnub?.subscribeToChannels(rooms, withPresence: true)
    }
    
    func disconnect() {
        // TODO: Not sure if i ever want to disconnect it's too much fun
        self.pubnub?.unsubscribeFromAll()
    }
    
    // TODO: Remove after testing
    func sendTestMessage() {
        self.pubnub?.publish("Hello from iOS ;)", toChannel: self.testPubChannel, withCompletion: { (status) in
            print("Sent test message with status: \(status.isError)")
        })
    }
}

enum NotificationType: String {
    case taskCompleted = "task_completed"
    case taskAssigned = "task_assigned"
    case updateRequestReceived = "update_request"
    case updateReceived = "update"
}

extension SocketManager: PNObjectEventListener {
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        print("received message for channel: \(message.data.subscription)")
        print("message: \(message.data.message)")
        
        // Make sure we're on the main thread
        OperationQueue.main.addOperation {
            self.process(message: message)
        }
    }
    
    func process(message: PNMessageResult) {
        let json = message.data.message as! [String: AnyObject]
        let type = json["type"] as! String
        let notificationType = NotificationType(rawValue: type)!
        
        switch notificationType {
        case .taskCompleted:
            let taskJSON = json["task"] as! [String: AnyObject]
            self.processTaskCompletedNotification(json: taskJSON)
        case .taskAssigned:
            let taskInvitationJSON = json["task_invitation"] as! [String: AnyObject]
            self.processTaskAssignedNotification(json: taskInvitationJSON)
        case .updateRequestReceived:
            let updateJSON = json["update"] as! [String: AnyObject]
            self.processUpdateReceivedNotification(json: updateJSON)
        case .updateReceived:
            let updateJSON = json["update"] as! [String: AnyObject]
            self.processUpdateResponseReceivedNotification(json: updateJSON)
        }
    }
    
    func processTaskCompletedNotification(json: [String: AnyObject]) {
        let taskId = Task.from(json: json, context: CoreDataStack.shared.context).objectId
        
        CoreDataStack.shared.saveContext()
        
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        let predicate = NSPredicate(format: "objectId == %@", taskId)
        fetchRequest.predicate = predicate
        
        do {
            let tasks = try CoreDataStack.shared.context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [Task]
            let task = tasks.first!
            AlertManager.presentPassiveAlert(of: .completed, with: task)
        } catch {
            print("core data socket error: \(error)")
        }
    }

    
    func processTaskAssignedNotification(json: [String: AnyObject]) {
        let taskInvitationId = TaskInvitation.from(json: json, context: CoreDataStack.shared.context).objectId
        
        CoreDataStack.shared.saveContext()
        
        let fetchRequest = NSFetchRequest<TaskInvitation>(entityName: "TaskInvitation")
        let predicate = NSPredicate(format: "objectId == %@", taskInvitationId)
        fetchRequest.predicate = predicate
        
        do {
            let taskInvitations = try CoreDataStack.shared.context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [TaskInvitation]
            let taskInvitation = taskInvitations.first!
            AlertManager.presentPassiveAlert(of: .assigned, with: taskInvitation)
        } catch {
            print("core data socket error: \(error)")
        }
    }
    
    func processUpdateReceivedNotification(json: [String: AnyObject]) {
        let updateId = Update.from(json: json, context: CoreDataStack.shared.context).objectId
        
        CoreDataStack.shared.saveContext()
        
        let fetchRequest = NSFetchRequest<Update>(entityName: "Update")
        let predicate = NSPredicate(format: "objectId == %@", updateId)
        fetchRequest.predicate = predicate
        
        do {
            let updates = try CoreDataStack.shared.context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [Update]
            let update = updates.first!
            AlertManager.presentAlert(ofType: .update, with: update)
        } catch {
            print("core data socket error: \(error)")
        }
    }
    
    func processUpdateResponseReceivedNotification(json: [String: AnyObject]) {
        let updateId = Update.from(json: json, context: CoreDataStack.shared.context).objectId
        
        CoreDataStack.shared.saveContext()
        
        let fetchRequest = NSFetchRequest<Update>(entityName: "Update")
        let predicate = NSPredicate(format: "objectId == %@", updateId)
        fetchRequest.predicate = predicate
        
        do {
            let updates = try CoreDataStack.shared.context.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>) as! [Update]
            let update = updates.first!
            AlertManager.presentPassiveAlert(of: .update, with: update)
        } catch {
            print("core data socket error: \(error)")
        }
    }
    
    func client(client: PubNub, didReceiveStatus status: PNStatus) {
        print("Did receive status: \(status)")
        
        if status.category == .PNUnexpectedDisconnectCategory {
            print("disconnected status")
            // This event happens when radio / connectivity is lost
        }
        else if status.category == .PNConnectedCategory {
            print("connected status")
            // Connect event. You can do stuff like publish, and know you'll get it.
            // Or just use the connected event to confirm you are subscribed for
            // UI / internal notifications, etc
        }
        else if status.category == .PNReconnectedCategory {
            print("reconnected status")
            // Happens as part of our regular operation. This event happens when
            // radio / connectivity is lost, then regained.
        }
        else if status.category == .PNDecryptionErrorCategory {
            print("decryption error status")
            // Handle messsage decryption error. Probably client configured to
            // encrypt messages and on live data feed it received plain text.
        }
    }
    
    func client(_ client: PubNub, didReceivePresenceEvent event: PNPresenceEventResult) {
        switch event.data.presenceEvent {
        case "join":
            print("join presence event!")
        case "leave":
            print("leave presence event!")
        case "timeout":
            print("timeout presence event!")
        default:
            break
        }
    }
}
