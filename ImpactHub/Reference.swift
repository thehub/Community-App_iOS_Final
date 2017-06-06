//
//  Reference.swift
//  MembershipApp
//
//  Created by Niklas on 21/03/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation

struct Reference {
    var id: String
    var url: String
}

extension Reference {
    init?(json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let url = json["url"] as? String
            else {
                return nil
            }
        self.id = id
        self.url = url
    }
}
