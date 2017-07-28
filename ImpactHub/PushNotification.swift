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
    var chatterGroupId: String?
    var createdDate: Date
    var profilePic: String?
    var kind: Kind
    var message: String
    
    enum Kind {
        case comment(id: String, feedElementId: String, chatterGroupId: String)
        case commentMention(commentId: String, chatterGroupId: String)
        case postMention(postId: String, chatterGroupId: String)
        case likePost(postId: String, chatterGroupId: String)
        case likeComment(commentId: String, chatterGroupId: String)
        case privateMessage(conversationId: String)
        case contactRequestIncomming(fromUserId: String)
        case contactRequestApproved(fromUserId: String)
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
        self.chatterGroupId = json["ChatterGroupId__c"].string  // FIXME: Once neela added this
        self.id = id
        self.message = message
        switch type {
        case "Comment":
            self.kind = .comment(id: relatedId, feedElementId: relatedId, chatterGroupId: chatterGroupId ?? "")
        case "PostMention":
            self.kind = .postMention(postId: relatedId, chatterGroupId: chatterGroupId ?? "")
        case "CommentMention":
            self.kind = .commentMention(commentId: relatedId, chatterGroupId: chatterGroupId ?? "")
        case "LikePost":
            self.kind = .likePost(postId: relatedId, chatterGroupId: chatterGroupId ?? "")
        case "LikeComment":
            self.kind = .likeComment(commentId: relatedId, chatterGroupId: chatterGroupId ?? "")
        case "PrivateMessage":
            self.kind = .privateMessage(conversationId: relatedId)
        case "DMRequestSent":
            self.kind = .contactRequestIncomming(fromUserId: fromUserId)
        case "DMRequestApproved":
            self.kind = .contactRequestApproved(fromUserId: fromUserId)
        default:
            print("Error DMRequest of unknown type")
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
    // Creates a PiushNotification form the incoming opush pyaload, so we can pass this around and open the correct view. This is handled in TabBarController.swft.
    // Note, PushNotification object is the same object used when loading in the istory of push notifications in the NotificationsViewController form the server. Since the payload being sent out int he push as opposed to when loaded form server won't have all the data we create an object with the other data set to nil or "". This way we can still get the relevant .kind properties and deeplink.
    static func createFromUserInfo(_ userInfo: [AnyHashable: Any]) -> PushNotification? {
        if let type = userInfo["type"] as? String {
            switch type.lowercased() {
            case "comment":
                if let id = userInfo["id"] as? String, let feedElementId = userInfo["feedElementId"] as? String, let chatterGroupId = userInfo["relatedGroup"] as? String {
                    return PushNotification(id: "", fromUserId: "", isRead: false, relatedId: "", chatterGroupId: chatterGroupId, createdDate: Date(), profilePic: nil, kind: PushNotification.Kind.comment(id: id, feedElementId: feedElementId, chatterGroupId: chatterGroupId), message: "")
                }
                else {
                    return nil
                }
            case "postmention", "commentmention":
                if let postId = userInfo["postId"] as? String, let chatterGroupId = userInfo["relatedGroup"] as? String {
                    return PushNotification(id: "", fromUserId: "", isRead: false, relatedId: "", chatterGroupId: chatterGroupId, createdDate: Date(), profilePic: nil, kind: PushNotification.Kind.postMention(postId: postId, chatterGroupId: chatterGroupId), message: "")
                }
                else {
                    return nil
                }
            case "dmrequestcreate":
                if let relatedId = userInfo["relatedId"] as? String {
                    return PushNotification(id: "", fromUserId: "", isRead: false, relatedId: "", chatterGroupId: "", createdDate: Date(), profilePic: nil, kind: PushNotification.Kind.contactRequestIncomming(fromUserId: relatedId), message: "")
                }
                else {
                    return nil
                }
            case "dmrequestapproved":
                if let relatedId = userInfo["relatedId"] as? String {
                    return PushNotification(id: "", fromUserId: "", isRead: false, relatedId: "", chatterGroupId: "", createdDate: Date(), profilePic: nil, kind: PushNotification.Kind.contactRequestApproved(fromUserId: relatedId), message: "")
                }
                else {
                    return nil
                }
            case "likepost":
                if let postId = userInfo["postId"] as? String, let chatterGroupId = userInfo["relatedGroup"] as? String {
                    return PushNotification(id: "", fromUserId: "", isRead: false, relatedId: "", chatterGroupId: chatterGroupId, createdDate: Date(), profilePic: nil, kind: PushNotification.Kind.likePost(postId: postId, chatterGroupId: chatterGroupId), message: "")
                }
                else {
                    return nil
                }
            case "message":
                if let conversationId = userInfo["conversationId"] as? String {
                    return PushNotification(id: "", fromUserId: "", isRead: false, relatedId: "", chatterGroupId: nil, createdDate: Date(), profilePic: nil, kind: PushNotification.Kind.privateMessage(conversationId: conversationId), message: "")
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


