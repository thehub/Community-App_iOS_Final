//
//  Subscription.swift
//  MembershipApp
//
//  Created by Niklas on 03/04/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Subscription {
    
    var id: String
    var subjectId: String?
    var chatterActor: ChatterActor? // Not all subscriptions are User, can be Group etc.
}

extension Subscription {
    init?(json: JSON) {
//        debugPrint(json)
        guard
            let id = json["id"].string,
            let subjectId = json["subject"]["id"].string
            else {
                return nil
        }
        self.id = id
        self.subjectId = subjectId
        
        if let subjectJson = json["subject"].dictionaryObject, let chatterActor = ChatterActor(userJson: subjectJson) {
            self.chatterActor = chatterActor
        }
        
    }
    
}
