//
//  Message.swift
//  MembershipApp
//
//  Created by Niklas on 21/03/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation

struct Message {
    var id: String
    var messageSegments: [String : Any]?
    var text: String
    var conversationId: String?
    var recipients: [User]
    var sentDate: Date
    var sender: User
}

extension Message {
    init?(json: [String: Any]) {
        debugPrint(json)
        guard
            let id = json["id"] as? String,
            let body = json["body"] as? [String : Any],
            let recipientsJson = json["recipients"] as? [[String : Any]],
            let sendDateISOString = json["sentDate"] as? String,
            let senderJson = json["sender"] as? [String: Any]
            else {
                return nil
        }
        
        self.id = id
        self.text = body["text"] as? String ?? ""
        self.messageSegments = body["messageSegments"] as? [String: Any] ?? nil
        self.sentDate = sendDateISOString.dateFromISOString()!

        if let conversationId = json["conversationId"] as? String {
            self.conversationId = conversationId
        }

        self.recipients = recipientsJson.flatMap { User(json: $0) }
        
        if let sender = User(json: senderJson) {
            self.sender = sender
        }
        else {
            return nil
        }
        
        
        
        
    }
    
}
