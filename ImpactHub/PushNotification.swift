//
//  Notification.swift
//  MembershipApp
//
//  Created by Niklas on 04/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

struct PushNotification {
    var id: String
    var fromUserId: String
    var isRead: Bool
    var relatedId: String
    var createdDate: Date
    var kind: Kind
    
    enum Kind {
        case comment(id: String, feedElementId: String)
        case mention(postId: String)
        case unknown
    }

}

extension PushNotification {
    init?(json: JSON) {
        guard
            let id = json["Id"].string,
            let type = json["Type__c"].string,
            let fromUserId = json["FromUserId__c"].string,
            let relatedId = json["RelatedId__c"].string,
            let createdDate = json["CreatedDate"].string?.dateFromISOString()
            else {
                return nil
        }
        self.id = id
        switch type {
        case "Comment":
            self.kind = .comment(id: relatedId, feedElementId: relatedId)
            break
        case "Mention":
            self.kind = .mention(postId: relatedId)
            break
        default:
            self.kind = .unknown
            break
        }
        
        self.fromUserId = fromUserId
        self.relatedId = relatedId
        self.createdDate = createdDate
        self.isRead = json["isRead__c"].bool ?? false
    }
    
}

extension PushNotification {
    static func createFromUserInfo(_ userInfo: [AnyHashable: Any]) -> PushNotification.Kind? {
        if let type = userInfo["type"] as? String {
            switch type {
            case "comment":
                if let id = userInfo["id"] as? String, let feedElementId = userInfo["feedElementId"] as? String {
                    return PushNotification.Kind.comment(id: id, feedElementId: feedElementId)
                }
                else {
                    return nil
                }
            case "mention":
                if let postId = userInfo["postId"] as? String {
                    return PushNotification.Kind.mention(postId: postId)
                }
                else {
                    return nil
                }
            default:
                return nil
            }
        }
        else {
            return nil
        }
    }
}
