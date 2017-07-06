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
    var chatterId: String
    var name: String
    var description: String?
    var image: String?
    var memberCount: Int
    var companyName: String?
    var companyId: String?
    var impactHubCities: String?
    var locationName: String?
    var objectives = [Objective]()
    var createdById: String
    
    
    struct Objective {
        var number: Int = 0
        var title: String
        var description: String
        var name: String
        var isLast: Bool = false
        
        
        mutating func setNumber(number: Int) {
            self.number = number
        }

        mutating func setIsLast(isLast: Bool) {
            self.isLast = isLast
        }

        init?(json: JSON) {
            guard
                let title = json["Goal__c"].string,
                let name = json["Name"].string,
                let description = json["Goal_Summary__c"].string
                else {
                    return nil
            }
            self.title = title
            self.name = name
            self.description = description
        }
    }
    
    
    // For mock testing
    init(name: String, image: String) {
        self.id = "asdsad"
        self.name = name
        self.image = image
        self.memberCount = 2
        self.chatterId = "dsfds"
        self.createdById = "ddf"
    }
    
}


extension Project {
    init?(json: JSON) {
        guard
            let id = json["Id"].string,
            let name = json["Name"].string,
            let chatterId = json["ChatterGroupId__c"].string,
            let createdById = json["CreatedById"].string
            else {
                return nil
        }
        self.id = id
        self.createdById = createdById
        self.chatterId = chatterId
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
