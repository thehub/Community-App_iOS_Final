//
//  Contact.swift
//  MembershipApp
//
//  Created by Niklas on 08/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation
import SalesforceSDKCore
import SwiftyJSON

struct Contact {
    var id: String
    var userId: String
    var firstName: String
    var lastName: String
    internal var profilePic: String?

    var profession: String?
    var skills: [String]?
    var aboutMe: String?
    var city: String?
    var country: String?
    var taxonomy: String?
    var job: String = ""
    var locationName: String = ""
    var impactHubCities: String = ""

    
    var fullName: String {
        get {
            return "\(firstName) \(lastName)"
        }
    }
}

extension Contact {
    init?(json: JSON) {
//        print(json)
        guard
            let id = json["Id"].string,
            let userId = json["User__c"].string,
            let firstName = json["FirstName"].string,
            let lastName = json["LastName"].string
            else {
                return nil
        }
        self.id = id
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.profilePic = json["ProfilePic__c"].string
        self.aboutMe = json["About_Me__c"].string
        self.profession = json["Profession__c"].string
        self.taxonomy = json["Taxonomy__c"].string
        if let skills = json["Skills__c"].string {
            self.skills = skills.components(separatedBy: ",")
        }
        
        if let profession = json["Profession__c"].string, profession != "<null>" {
            self.job = profession
        }
        
        if let impactHubCities = json["Impact_Hub_Cities__c"].string, impactHubCities != "<null>" {
            self.impactHubCities = impactHubCities
            if let firstCity = impactHubCities.components(separatedBy: ";").first {
                self.locationName = firstCity
            }
        }

    }
}

extension Contact {
    var profilePicUrl: URL? {
        if let token = SFUserAccountManager.sharedInstance().currentUser?.credentials.accessToken,
            let photo = self.profilePic,
            let url = URL(string: "\(photo)?oauth_token=\(token)") {
            return url
        }
        return nil
    }
    
}
