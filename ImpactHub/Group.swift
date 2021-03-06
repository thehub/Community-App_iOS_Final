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
    var chatterId: String
    var name: String
    var image: String?
    var description: String?
    var memberCount = 0
    var impactHubCities: String?
    var locationName: String?
    var sector: String?
    var relatedSDGs: String?
    var groupType: GroupType // Public  // Private
    
    enum GroupType: String {
        case `public`
        case `private`
    }
}


extension Group {
    init?(json: JSON) {
        guard
            let id = json["Id"].string,
            let name = json["Name"].string,
            let chatterId = json["ChatterGroupId__c"].string,
            let groupTypeString = json["ChatterGroupType__c"].string?.lowercased(),
            let groupType = Group.GroupType(rawValue: groupTypeString)
            else {
                return nil
        }
        self.id = id
        self.name = name
        self.chatterId = chatterId
        self.description = json["Group_Descr__c"].string
        self.memberCount = json["CountOfMembers__c"].intValue
        self.groupType = groupType
        
        if let image = json["ImageURL__c"].string {
            self.image = image
        }
        
        if let impactHubCities = json["Impact_Hub_Cities__c"].string, impactHubCities != "<null>" {
            self.impactHubCities = impactHubCities
            if let firstCity = impactHubCities.components(separatedBy: ";").first {
                self.locationName = firstCity
            }
        }
        
        self.sector = json["Sector__c"].string
        self.relatedSDGs = json["Related_Impact_Goal__c"].string

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

