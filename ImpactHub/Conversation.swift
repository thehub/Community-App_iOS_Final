//
//  Conversation.swift
//  MembershipApp
//
//  Created by Niklas on 21/03/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation

struct Conversation {
    var id: String
    var latestMessage: Message
    var members: [User]
    var read: Bool
    var messages: [Message]?
}

extension Conversation {
    init?(json: [String: Any]) {
//        debugPrint(json)
        guard
            let id = json["id"] as? String,
            let latestMessageJson = json["latestMessage"] as? [String: Any],
            let membersJson = json["members"] as? [[String: Any]],
            let read = json["read"] as? Bool
            else {
                return nil
        }

        self.id = id
        if let message = Message(json: latestMessageJson) {
            self.latestMessage = message
        }
        else {
            return nil
        }
        self.members = membersJson.flatMap { User(json: $0) }
        
        if let messagesJson = json["messages"] as? [[String: Any]] {
            self.messages = messagesJson.flatMap { Message(json: $0) }
        }
        
        self.read = read
    }
    
}
