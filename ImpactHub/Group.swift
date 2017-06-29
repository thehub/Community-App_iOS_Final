//
//  Group.swift
//  MembershipApp
//
//  Created by Niklas on 29/11/2016.
//  Copyright © 2016 Lightful Ltd. All rights reserved.
//

import Foundation
import SalesforceSDKCore
import SwiftyJSON


struct Group {
    var id: String
    var name: String
    var image: String?
    var description: String?
    var memberCount = 0
    var impactHubCities: String?
    var locationName: String?
    
    // For mock testing
    init(id: String, name: String, image: String, description: String, memberCount: Int, locationName: String) {
        self.id = "asdsad"
        self.name = name
        self.image = image
        self.memberCount = 2
    }
}


extension Group {
    init?(json: JSON) {
        guard
            let id = json["Id"].string,
            let name = json["Name"].string
            else {
                return nil
        }
        self.id = id
        self.name = name
        self.description = json["Group_Desc__c"].string
        self.memberCount = json["CountOfMembers__c"].intValue
        
        if let image = json["ImageURL__c"].string {
            self.image = image
        }
        
        if let impactHubCities = json["Impact_Hub_Cities__c"].string, impactHubCities != "<null>" {
            self.impactHubCities = impactHubCities
            if let firstCity = impactHubCities.components(separatedBy: ";").first {
                self.locationName = firstCity
            }
        }
    }
}


extension Group {
    var photoUrl: URL? {
        if let token = SFUserAccountManager.sharedInstance().currentUser?.credentials.accessToken,
            let photo = self.image,
            let url = URL(string: "\(photo)?oauth_token=\(token)") {
            return url
        }
        return nil
    }
}


//extension Group {
//    init?(json: [AnyHashable: Any]) {
//        
//        debugPrint(json)
//        
//        if let id = json["id"] as? String {
//            self.id = id
//        }
//        else {
//            return nil
//        }
//        
//        if let name = json["name"] as? String {
//            self.name = name
//        }
//        else {
//            return nil
//        }
//        
//        if let memberCount = json["memberCount"] as? Int {
//            self.memberCount = memberCount
//        }
//        
//        if let visibility = json["visibility"] as? String, visibility == "PublicAccess" {
//            
//        }
//        else {
//            return nil
//        }
//
//        self.description = ""
//        self.image = "" // TODO:
//        
//    }
//    
//    init?(jsonDirectory: [AnyHashable: Any]) {
//        
//        debugPrint(jsonDirectory)
//        
//        if let id = jsonDirectory["ChatterGroupId__c"] as? String, id != "<null>" {
//            self.id = id
//        }
//        else {
//            return nil
//        }
//        
//        if let name = jsonDirectory["Name"] as? String, name != "<null>" {
//            self.name = name
//        }
//        else {
//            return nil
//        }
//        
//        if let visibility = jsonDirectory["visibility"] as? String, visibility == "PublicAccess" {
//            
//        }
//        else {
//            return nil
//        }
//        
//        self.description = "Body..."
//        self.image = "" // TODO:
//        
//    }
//}
