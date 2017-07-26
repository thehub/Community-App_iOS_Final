//
//  ChatterSegmentBuilder.swift
//  MembershipApp
//
//  Created by Niklas Alvaeus on 30/03/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

class ChatterSegmentBuilder {
    
    func attributedTextFromSegments(segments: [MessageSegment]) -> NSAttributedString {
        
        let attributes = [ NSFontAttributeName: UIFont(name: "GTWalsheim-Light", size: 14.0)!, NSForegroundColorAttributeName : UIColor(hexString: "716F81")]
        let textToShow = NSMutableAttributedString()
        
        segments.forEach({ (segment) in
            
            if segment is Text {
                textToShow.append(NSAttributedString(string: segment.text, attributes: attributes))
            }
            else if segment is Mention {
                let mention = segment as! Mention
                let mentionString = NSMutableAttributedString(string: segment.text, attributes: attributes)
                // TODO: How to determain wether the current user can access this mention link?
                //                    if segment["record"]["visibility"].string == "PublicAccess" {
                _ = mentionString.setAsLink(textToFind: segment.text, linkURL: URL.init(string: "mention://\(mention.record["id"].stringValue)")!)
                textToShow.append(mentionString)
                //                    }
            }
            else if segment is EntityLink {
                let link = segment as! EntityLink
                let linkString = NSMutableAttributedString(string: link.text, attributes: attributes)
                _ = linkString.setAsLink(textToFind: link.text, linkURL: URL.init(string: link.url)!)
                textToShow.append(linkString)
            }
        })
        return textToShow
    }
    
    // Build segements according to https://developer.salesforce.com/docs/atlas.en-us.chatterapi.meta/chatterapi/quickreference_post_comment_or_feed_item_with_mentions.htm
    func buildSegmentsFrom(text: String, mentionCompletions:[MentionCompletion]) -> [[String: String]] {
        var segments = [[String: String]]()
        let components = text.components(separatedBy: "@")
        
        components.forEach({ (component) in
            if let mentionCompletion = mentionCompletions.first(where: { (mentionCompletion) -> Bool in
                if component.contains(mentionCompletion.name) {
                    return true
                }
                else {
                    return false
                }
            }) {
                let textToUse = component.components(separatedBy: mentionCompletion.name)
                let segment = ["type": "Mention", "id": mentionCompletion.recordId]
                segments.append(segment)
                if textToUse.count > 1 {
                    let segment2 = ["type": "Text", "text": textToUse[1]]
                    segments.append(segment2)
                }
            }
            else {
                let segment = ["type": "Text", "text": component]
                segments.append(segment)
            }
        })
        return segments
    }
    
}
