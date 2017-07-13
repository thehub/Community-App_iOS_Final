//
//  Member.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation
import SalesforceSDKCore
import SwiftyJSON


class Member {
    var id: String
    var userId: String
    var firstName: String
    var lastName: String
    var job: String = ""
    var photo: String?
    var blurb: String = ""
    var aboutMe: String = ""
    var locationName: String = ""
    var impactHubCities: String = ""
    var skills = [Skill]()
    var social: Social?
    var contactRequest: DMRequest?
    
    struct Social {
        var instagram: URL?
        var twitter: String?
        var linkedIn: URL?
        var facebook: URL?
    }

    
    struct Skill {
        var id: String
        var name: String
        var description: String?
        
        init?(json: JSON) {
            print(json)
            guard
                let id = json["Id"].string,
                let name = json["Name"].string
                else {
                    return nil
            }
            self.id = id
            self.name = name
            self.description = json["Skill_Description__c"].string
        }

    }
    
    
    init?(json: JSON) {
        print(json)
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
        
        if let profilePic = json["ProfilePic__c"].string {
            self.photo = profilePic
        }
        
        if let aboutMe = json["About_Me__c"].string, aboutMe != "<null>" {
            self.aboutMe = aboutMe
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
        
        var instagram: URL?
        var facebook: URL?
        var linkedIn: URL?
        if let tmp = json["Instagram__c"].string {
            instagram = URL(string: tmp)
        }
        if let tmp = json["LinkedIn__c"].string {
            linkedIn = URL(string: tmp)
        }
        if let tmp = json["Facebook__c"].string {
            facebook = URL(string: tmp)
        }
        let twitter = json["Twitter__c"].string
        self.social = Social(instagram: instagram, twitter: twitter, linkedIn: linkedIn, facebook: facebook)
        
        
        
        //        if let taxonomy = json["Taxonomy__c"].string {
        //            self.taxonomy = taxonomy
        //        }
        //
        //        if let skills = json["Skills__c"].string {
        //            self.skills = skills.components(separatedBy: ",")
        //        }
        
        
    }
    
    // For mock testing
//    init(id: String, userId: String, firstName: String, lastName: String, job: String, photo: String, blurb: String, aboutMe: String, locationName: String) {
//        self.id = id
//        self.userId = userId
//        self.firstName = firstName
//        self.lastName = lastName
//        self.job = job
//        self.photo = photo
//        self.blurb = blurb
//        self.aboutMe = aboutMe
//        self.locationName = locationName
//    }
    
}



extension Member {
    var name: String {
        get {
            return "\(firstName) \(lastName)"
        }
    }
}

extension Member {
    var photoUrl: URL? {
        
        if let token = SFUserAccountManager.sharedInstance().currentUser?.credentials.accessToken,
            let photo = self.photo,
//            let url = URL(string: "\(photo)?oauth_token=\(token)") {
            let url = URL(string: "\(photo)?oauth_token=\(token)") {
            return url
        }
        return nil
    }
}
