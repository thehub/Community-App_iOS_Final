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
        let encodedText = body["text"] as? String ?? ""
        self.text = String(htmlEncodedString:encodedText) ?? ""
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

extension Message {
    func otherUser() -> User {
        // Find the other user
        if self.sender.id != SessionManager.shared.me!.member.userId {
            return self.sender
        }
        else {
            var recipientNotMe = self.sender
            for recipient in self.recipients {
                if recipient.id != SessionManager.shared.me?.member.userId {
                    recipientNotMe = recipient
                    break
                }
            }
            return recipientNotMe
        }
    }
}
