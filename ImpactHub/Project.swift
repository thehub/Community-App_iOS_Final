//
//  Project.swift
//  ImpactHub
//
//  Created by Niklas on 19/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation
import SalesforceSDKCore
import SwiftyJSON


struct Project {
    
    var id: String
    var name: String
    var description: String?
    var image: String?
    var memberCount: Int
    var companyName: String?
    var companyId: String?
    var impactHubCities: String?
    var locationName: String?
    var objectives: [Project.Objective] {
        get {
            let objective1 = Objective(number: 1, title: "Objective", description: "Lorem ipsum dolor sit amet, consectetur adipiscing eli Lorem ipsum dolor sit amet, consectetur adipiscing eli Lorem ipsum dolor sit amet, consectetur adipiscing eli Lorem ipsum dolor sit amet, consectetur adipiscing eli.", isLast: false)
            let objective2 = Objective(number: 2, title: "Objective", description: "Lorem ipsum dolor sit amet, consectetur adipiscing eli Lorem ipsum dolor sit amet, consectetur adipiscing eli Lorem ipsum dolor sit amet, consectetur adipiscing eli Lorem ipsum dolor sit amet, consectetur adipiscing eli.", isLast: false)
            let objective3 = Objective(number: 3, title: "Objective", description: "Lorem ipsum dolor sit amet, consectetur adipiscing eli Lorem ipsum dolor sit amet, consectetur adipiscing eli Lorem ipsum dolor sit amet, consectetur adipiscing eli Lorem ipsum dolor sit amet, consectetur adipiscing eli.", isLast: false)
            let objective4 = Objective(number: 4, title: "Objective", description: "Lorem ipsum dolor sit amet, consectetur adipiscing eli Lorem ipsum dolor sit amet, consectetur adipiscing eli Lorem ipsum dolor sit amet, consectetur adipiscing eli Lorem ipsum dolor sit amet, consectetur adipiscing eli.", isLast: true)

            return [objective1, objective2, objective3, objective4]
        }
    }
    
    
    struct Objective {
        var number: Int
        var title: String
        var description: String
        var isLast: Bool
    }
    
    
    // For mock testing
    init(name: String, image: String) {
        self.id = "asdsad"
        self.name = name
        self.image = image
        self.memberCount = 2
    }
    
}


extension Project {
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
        
        self.companyId = json["Organisation__c"].string
        
        self.companyName = json["Organisation__r"]["Name"].string
        
        if let impactHubCities = json["Impact_Hub_Cities__c"].string, impactHubCities != "<null>" {
            self.impactHubCities = impactHubCities
            if let firstCity = impactHubCities.components(separatedBy: ";").first {
                self.locationName = firstCity
            }
        }
        if let image = json["ImageURL__c"].string {
            self.image = image
        }

    }
}


extension Project {
    var photoUrl: URL? {
        if let token = SFUserAccountManager.sharedInstance().currentUser?.credentials.accessToken,
            let photo = self.image,
            let url = URL(string: "\(photo)?oauth_token=\(token)") {
//            let url = URL(string: "\(Constants.host)\(photo)?oauth_token=\(token)") {
            return url
        }
        return nil
    }
}
