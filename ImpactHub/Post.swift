//
//  Post.swift
//  MembershipApp
//
//  Created by Niklas Alvaeus on 16/02/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation
import SalesforceSDKCore
import SwiftyJSON

struct Post {
    
    var text: String
    var blurb: String
    var group: Group?
    var date: Date
    var id: String?
    var likes: Int = 0
    var isLikedByCurrentUser = false
    var comments = [Comment]()
    var commentsCount: Int = 0
    var commentsNextPageUrl: String?
    var chatterActor: ChatterActor
    var file: File?
    var segments: [MessageSegment]
    
    struct File {
        var id: String
        var renditionUrl: String
        var downloadUrl: String
        var mimeType: String
        var title: String
        var sharingOption: String
        var description: String?
        
        init?(json: [String: Any]) {
            print(json)
            guard
                let id = json["id"] as? String,
                let renditionUrl = json["renditionUrl"] as? String,
                let downloadUrl = json["downloadUrl"] as? String,
                let mimeType = json["mimeType"] as? String,
                let title = json["title"] as? String,
                let sharingOption = json["sharingOption"] as? String
                else {
                    return nil
            }
            self.id = id
            self.renditionUrl = renditionUrl
            self.downloadUrl = downloadUrl
            self.mimeType = mimeType
            self.title = title
            self.sharingOption = sharingOption
            self.description = json["description"] as? String
        }
        
        var url: URL? {
            if let token = SFUserAccountManager.sharedInstance().currentUser?.credentials.accessToken,
                let url = URL(string: "\(Constants.host)\(renditionUrl)&oauth_token=\(token)") {
                return url
            }
            return nil
        }
    }
    
}

extension Post {
    init?(json: JSON) {
        guard
            let postedTimeString = json["createdDate"].string,
            let postedTime = postedTimeString.dateFromISOString(),
            let id = json["id"].string,
            let actor = json["actor"].dictionaryObject
            else {
                return nil
        }
        
        self.text = json["body"]["text"].string ?? ""
        self.blurb = text
        self.date = postedTime
        self.id = id
        
        let segmentsJson = json["body"]["messageSegments"].arrayValue
        self.segments = segmentsJson.flatMap({ MessageSegmentCreator.createFrom(json: $0) })
        
        self.likes = json["capabilities"]["chatterLikes"]["page"]["total"].int ?? 0
        self.isLikedByCurrentUser = json["capabilities"]["chatterLikes"]["isLikedByCurrentUser"].bool ?? false
        
        if let fileJson = json["capabilities"]["files"]["items"].array?.first?.dictionaryObject {
            if let file = File(json: fileJson) {
                self.file = file
            }
        }
        
        if let chatterActor = ChatterActor(userJson: actor) {
            self.chatterActor = chatterActor
        }
        else {
            return nil
        }
        
        self.commentsCount = json["capabilities"]["comments"]["page"]["total"].int ?? 0
        
        self.commentsNextPageUrl = json["capabilities"]["comments"]["page"]["nextPageUrl"].string ?? nil
        if let comments = json["capabilities"]["comments"]["page"]["items"].array {
            self.comments = comments.reversed().flatMap { Comment(json: $0) }
        }
    }
    
}
