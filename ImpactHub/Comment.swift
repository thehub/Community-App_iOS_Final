//
//  Comment.swift
//  MembershipApp
//
//  Created by Niklas Alvaeus on 16/12/2016.
//  Copyright © 2016 Lightful Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

class Comment {
    
    var body: String
    var groupID: String
    var date: Date
    var user: User?
    var id: String
    var likes: Int = 0
    // This is not coming out from chatter api on a comment so use myLikeId
    var isLikedByCurrentUser: Bool {
        if myLikeId != nil {
            return true
        }
        else {
            return false
        }
    }
    var myLikeId: String?

    init?(json: JSON) {
        print(json)
        guard
            let postedTimeString = json["createdDate"].string,
            let postedTime = postedTimeString.dateFromISOString(),
            let text = json["body"]["text"].string,
            let id = json["id"].string,
            let userJson = json["user"].dictionaryObject
            else {
                return nil
        }
        self.body = text
        self.date = postedTime
        self.id = id
        if let user = User(json: userJson) {
            self.user = user
        }
        else {
            return nil
        }
        
        self.likes = json["likes"]["total"].int ?? 0
        
        // myLike
        self.myLikeId = json["capabilities"]["chatterLikes"]["myLike"]["id"].string
        
        
        self.groupID = ""
    }
}

extension Comment {


}
