//
//  Notification.swift
//  MembershipApp
//
//  Created by Niklas on 04/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON
import SalesforceSDKCore

struct PushNotification {
    var id: String
    var fromUserId: String
    var isRead: Bool
    var relatedId: String
    var createdDate: Date
    var profilePic: String?
    var kind: Kind
    var message: String
    
    enum Kind {
        case comment(id: String, feedElementId: String)
        case commentMention(commentId: String)
        case postMention(postId: String)
        case likePost(postId: String)
        case likeComment(commentId: String)
        case privateMessage(messageId: String)
        case contactRequestIncomming(contactId: String)
        case contactRequestApproved(contactId: String)
        case unknown
        
        func getParameter() -> String {
            switch self {
            case .comment:
                return "Comment"
            case .commentMention:
                return "CommentMention"
            case .postMention:
                return "PostMention"
            case .likePost:
                return "LikePost"
            case .likeComment:
                return "LikeComment"
            case .privateMessage:
                return "PrivateMessage"
            case .contactRequestIncomming:
                return "DMRequestSent"
            case .contactRequestApproved:
                return "DMRequestApproved"
            case .unknown:
                return ""
            }
        }
        
        func getIconImage() -> UIImage {
            switch self {
            case .comment:
                return UIImage(named: "notificationCommentIcon")!
            case .commentMention:
                return UIImage(named: "notificationMentionIcon")!
            case .postMention:
                return UIImage(named: "notificationMentionIcon")!
            case .likePost:
                return UIImage(named: "notificationLikeIcon")!
            case .likeComment:
                return UIImage(named: "notificationLikeIcon")!
            case .privateMessage:
                return UIImage(named: "notificationMessageIcon")!
            case .contactRequestIncomming:
                return UIImage(named: "notificationRequestContactIcon")!
            case .contactRequestApproved:
                return UIImage(named: "notificationAccepetedIcon")!
            case .unknown:
                return UIImage(named: "notificationCommentIcon")!
            }
        }
        
    }

}



extension PushNotification {
    init?(json: JSON) {
        print(json)
        guard
            let id = json["Id"].string,
            let type = json["Type__c"].string,
            let fromUserId = json["FromUserId__c"].string,
            let relatedId = json["RelatedId__c"].string,
            let createdDate = json["CreatedDate"].string?.dateFromISOString(),
            let message = json["Message__c"].string
            else {
                return nil
        }
        self.id = id
        self.message = message
        switch type {
        case "Comment":
            self.kind = .comment(id: relatedId, feedElementId: relatedId)
        case "PostMention":
            self.kind = .postMention(postId: relatedId)
        case "CommentMention":
            self.kind = .commentMention(commentId: relatedId)
        case "LikePost":
            self.kind = .likePost(postId: relatedId)
        case "LikeComment":
            self.kind = .likeComment(commentId: relatedId)
        case "PrivateMessage":
            self.kind = .privateMessage(messageId: relatedId)
        case "DMRequestCreate":
            self.kind = .contactRequestIncomming(contactId: fromUserId)
        case "DMRequestApproved":
            self.kind = .contactRequestApproved(contactId: fromUserId)
        default:
            self.kind = .unknown
        }
        
        self.fromUserId = fromUserId
        self.relatedId = relatedId
        self.createdDate = createdDate
        self.isRead = json["isRead__c"].bool ?? false
        
        self.profilePic = json["ProfilePicURL__c"].string
        
    }
    
}

extension PushNotification {
    static func createFromUserInfo(_ userInfo: [AnyHashable: Any]) -> PushNotification.Kind? {
        if let type = userInfo["type"] as? String {
            switch type {
            case "Comment":
                if let id = userInfo["id"] as? String, let feedElementId = userInfo["feedElementId"] as? String {
                    return PushNotification.Kind.comment(id: id, feedElementId: feedElementId)
                }
                else {
                    return nil
                }
            case "PostMention", "CommentMention":
                if let postId = userInfo["postId"] as? String {
                    return PushNotification.Kind.postMention(postId: postId)
                }
                else {
                    return nil
                }
            case "DMRequestCreate":
                if let relatedId = userInfo["relatedId"] as? String {
                    return PushNotification.Kind.contactRequestIncomming(contactId: relatedId)
                }
                else {
                    return nil
                }
            case "DMRequestApproved":
                if let relatedId = userInfo["relatedId"] as? String {
                    return PushNotification.Kind.contactRequestApproved(contactId: relatedId)
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

extension PushNotification {
    var profilePicUrl: URL? {
        if let token = SFUserAccountManager.sharedInstance().currentUser?.credentials.accessToken,
            let profilePic = self.profilePic,
            let url = URL(string: "\(profilePic)?oauth_token=\(token)") {
            return url
        }
        return nil
    }
}


