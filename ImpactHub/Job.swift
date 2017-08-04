//
//  Job.swift
//  MembershipApp
//
//  Created by Niklas on 24/04/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON
import SalesforceSDKCore



struct Job {
    var id: String
    var name: String
    var company: Company
    var description: String = ""
    var sector: String?
    var locationName: String
    var type: String
    var salary: String
    var logo: String?
    var photo: String?
    var relatedSDGs: String?
    var applicationURL: String?
}



extension Job {
    init?(json: JSON) {
        guard
            let id = json["Id"].string,
            let name = json["Name"].string,
            let type = json["Job_Type__c"].string,
            var companyJson = json["Company__r"].dictionary,
            let companyId = json["Company__c"].string,
            let salary = json["Salary__c"].string,
            let locationName = json["Location__c"].string
            else {
                return nil
        }
        self.id = id
        self.description = json["Description__c"].string ?? ""
        self.sector = json["Sector__c"].string
        self.name = name
        self.type = type
        self.salary = salary
        companyJson["Id"] = JSON.init(stringLiteral: companyId)
        if let company = Company(json: JSON(companyJson)) {
            self.company = company
        }
        else {
            return nil
        }
        self.locationName = locationName
        
        self.logo = json["Company__r"]["Logo_Image_Url__c"].string
        self.photo = json["Company__r"]["Banner_Image_Url__c"].string

        self.relatedSDGs = json["Related_Impact_Goal__c"].string
        
        self.applicationURL = json["Job_Application_URL__c"].string
    }
    
}

extension Job {
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
