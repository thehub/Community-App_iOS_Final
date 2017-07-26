//
//  Company.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 19/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON
import SalesforceSDKCore


struct Company {
    var id: String
    var name: String
    var photo: String?
    var logo: String?
    var about: String?
    var impactHubCities: String?
    var locationName: String?
    var website: String?
    var size: String?
    var sector: String?
    var social: Social?
    var blurb: String = "Some lines about this compnay"
    var services = [Service]()
    
    struct Social {
        var instagram: URL?
        var twitter: String?
        var linkedIn: URL?
        var facebook: URL?
    }
    
    struct Service {
        var name: String
        var description: String
        
        init?(json: JSON) {
            guard
                let description = json["Service_Description__c"].string,
                let name = json["Name"].string
                else {
                    return nil
            }
            self.description = description
            self.name = name
        }

    }

}

extension Company {
    init?(json: JSON) {
        guard
            let id = json["Id"].string,
            let name = json["Name"].string
            else {
                return nil
        }
        self.id = id
        self.name = name
        
        self.photo = json["Banner_Image_Url__c"].string
        self.logo = json["Logo_Image_Url__c"].string
        self.about = json["About_Us__c"].string
        if let impactHubCities = json["Impact_Hub_Cities__c"].string, impactHubCities != "<null>" {
            self.impactHubCities = impactHubCities
            if let firstCity = impactHubCities.components(separatedBy: ";").first {
                self.locationName = firstCity
            }
        }
        self.website = json["Website"].string
        self.size = json["Number_of_Employees__c"].string
        self.sector = json["Sector_Industry__c"].string
        
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
        
    }
    
}

extension Company {
    var photoUrl: URL? {
        if let token = SFUserAccountManager.sharedInstance().currentUser?.credentials.accessToken,
            let photo = self.photo,
            let url = URL(string: "\(photo)?oauth_token=\(token)") {
            return url
        }
        return nil
    }
    var logoUrl: URL? {
        if let token = SFUserAccountManager.sharedInstance().currentUser?.credentials.accessToken,
            let logo = self.logo,
            let url = URL(string: "\(logo)?oauth_token=\(token)") {
            return url
        }
        return nil
    }
}
