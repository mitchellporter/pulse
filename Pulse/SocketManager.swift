//
//  SocketManager.swift
//  Ginger
//
//  Created by Mitchell Porter on 1/13/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import PubNub

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
    
    func connect(user: User) {
        let config = PNConfiguration(publishKey: self.publishKey, subscribeKey: self.subscribeKey)
        config.uuid = user.name // TODO: I feel like both uuid and authKey should be set to user's objectId
        config.authKey = user.objectId // ????
        config.presenceHeartbeatInterval = 20
        config.presenceHeartbeatValue = 60
        
        self.pubnub = PubNub.clientWithConfiguration(config)
        self.pubnub?.logger.setLogLevel(0)
        self.pubnub?.addListener(self)
        
        let rooms = [self.testSubChannel, "hello_world", user.objectId]
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

extension SocketManager: PNObjectEventListener {
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        print("received message for channel: \(message.data.subscription)")
        print("message: \(message.data.message)")
//        let messageJSON = message.data.message as! [String: AnyObject]
//        let conversationJSON = messageJSON["conversation"] as! [String: AnyObject]
//        let message = Message.from(json: messageJSON) as! Message
//        let conversation = Conversation.from(json: conversationJSON) as! Conversation
//        conversation.objectId = "823974987234"
//        DataModelManager
        // type: new_message
        // conversation: conversation
        // message: message
        
        // 1. Parse the conversation
        // 2. Parse the message
        // 3. Send the conversation to the inbox controller
        // 4. Send the message to the conversation controller
        
        // I think 3 and 4 are wrong. I think you need to stop looking at this as "send these things to the controllers",
        // and instead look at it as "send these new things to our universal store, where the view controllers will fetch from anyways"
        // That way if they're in memory they get the update right away, and if not then it doesn't matter because they'll just pull it later anyways
//        DataModelManager.sharedInstance.updateModel(conversation)
//        DataModelManager.sharedInstance.updateModel(conversation)
//        CollectionDataProvider<Conversation>.append([conversation], cacheKey: CacheKey.inbox.key, dataModelManager: DataModelManager.sharedInstance)
//        CollectionDataProvider<Message>.append([message], cacheKey: CacheKey.conversation(id: conversation.objectId).key, dataModelManager: DataModelManager.sharedInstance)
//        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "lol"), object: nil, userInfo: message.data.message as! [AnyHashable : Any]?)
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
