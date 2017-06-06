//
//  MentionCompletion.swift
//  MembershipApp
//
//  Created by Niklas on 22/03/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation

struct MentionCompletion {
    var recordId: String
    var name: String
    var photoUrl: String?
}

extension MentionCompletion {
    init?(json: [String: Any]) {
        guard
            let recordId = json["recordId"] as? String,
            let name = json["name"] as? String
            else {
                return nil
        }
        self.recordId = recordId
        self.name = name
        
        if let photoUrl = json["photoUrl"] as? String {
            self.photoUrl = photoUrl
        }
        
    }
}
