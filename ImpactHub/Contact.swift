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
    var email: String
    internal var profilePic: String?

    var profession: String?
    var skills: [String]?
    var aboutMe: String?
    var city: String?
    var country: String?
    var taxonomy: String?

    
    var fullName: String {
        get {
            return "\(firstName ?? "") \(lastName ?? "")"
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
            let lastName = json["LastName"].string,
            let email = json["Email"].string
            else {
                return nil
        }
        self.id = id
        self.userId = userId
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        
        if let profilePic = json["ProfilePic__c"].string {
            self.profilePic = profilePic
        }

        if let aboutMe = json["About_Me__c"].string, aboutMe != "<null>" {
            self.aboutMe = aboutMe
        }
        
        if let profession = json["Profession__c"].string, profession != "<null>" {
            self.profession = profession
        }
        
        if let taxonomy = json["Taxonomy__c"].string {
            self.taxonomy = taxonomy
        }

        if let skills = json["Skills__c"].string {
            self.skills = skills.components(separatedBy: ",")
        }


    }
}

extension Contact {
    var profilePicUrl: URL? {
        if let token = SFUserAccountManager.sharedInstance().currentUser?.credentials.accessToken,
            let profilePic = self.profilePic,
            let url = URL(string: "\(profilePic)?oauth_token=\(token)") {
            return url
        }
        return nil
    }
    
}
