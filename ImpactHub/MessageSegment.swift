//
//  MessageSegment.swift
//  MembershipApp
//
//  Created by Niklas Alvaeus on 30/03/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON


protocol MessageSegment {

    var text: String { get set }

}

struct MessageSegmentCreator {
    static func createFrom(json: JSON) -> MessageSegment? {
        
        switch json["type"] {
            case "Text":
                let messageSegment = Text(json: json)
                return messageSegment
            case "Link":
                let messageSegment = EntityLink(json: json)
                return messageSegment
            case "Mention":
                let messageSegment = Mention(json: json)
            return messageSegment
            default:
                return nil
        }
    }
}


struct Text: MessageSegment {
    var text: String
    
    init?(json: JSON) {
        self.text = json["text"].stringValue
    }
}

struct EntityLink: MessageSegment {
    var url: String
    var text: String

    init?(json: JSON) {
        self.text = json["text"].stringValue
        self.url = json["url"].stringValue
    }
}

struct Mention: MessageSegment {
    var text: String
    var name: String
    var record: JSON
    
    init?(json: JSON) {
        self.text = json["text"].stringValue
        self.name = json["name"].stringValue
        self.record = json["record"]

    }
}




