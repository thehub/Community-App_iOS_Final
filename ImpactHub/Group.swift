//
//  Group.swift
//  MembershipApp
//
//  Created by Niklas on 29/11/2016.
//  Copyright © 2016 Lightful Ltd. All rights reserved.
//

import Foundation

struct Group {
    var id: String
    var title: String
    var body: String
    var memberCount = 0
}

extension Group {
    init?(json: [AnyHashable: Any]) {
        
        debugPrint(json)
        
        if let id = json["id"] as? String {
            self.id = id
        }
        else {
            return nil
        }
        
        if let name = json["name"] as? String {
            self.title = name
        }
        else {
            return nil
        }
        
        if let memberCount = json["memberCount"] as? Int {
            self.memberCount = memberCount
        }
        
        if let visibility = json["visibility"] as? String, visibility == "PublicAccess" {
            
        }
        else {
            return nil
        }

        self.body = ""
        
    }
    
    init?(jsonDirectory: [AnyHashable: Any]) {
        
        debugPrint(jsonDirectory)
        
        if let id = jsonDirectory["ChatterGroupId__c"] as? String, id != "<null>" {
            self.id = id
        }
        else {
            return nil
        }
        
        if let name = jsonDirectory["Name"] as? String, name != "<null>" {
            self.title = name
        }
        else {
            return nil
        }
        
        if let visibility = jsonDirectory["visibility"] as? String, visibility == "PublicAccess" {
            
        }
        else {
            return nil
        }
        
        self.body = "Body..."
        
    }
}
