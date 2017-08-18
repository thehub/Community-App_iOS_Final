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

struct Event {
    
    var id: String
    var name: String
    var date: Date
    var endDate: Date?
    var registerURL: String?
    var description: String = ""
    var groupId: String?
    var city: String
    var country: String =  ""
    var street: String = ""
    var postCode: String = ""
    var classification: String
    var discountCode: String?
//    var organiserType: String
    var quantity: String?
    var sector: String = ""
    var eventType: String
    var eventSubType: String = ""
    var organiserName: String
    var photo: String?
    var visibility: String = ""
    
//    static let EVENT = ",,,, ,,,,,,,,,,,Event_SubType__c,,Event_Visibility__c,LastModifiedDate,Organiser__c,,OwnerId"
}


extension Event {
    init?(json: JSON) {
//        print(json)
        guard
            let id = json["Id"].string,
            let name = json["Name"].string,
            let date = json["Event_Start_DateTime__c"].string?.dateFromISOString(),
            let city = json["Event_City__c"].string,
            let classification = json["Event_Classification__c"].string,
//            let organiserType = json["Event_Organiser_Type__c"].string,
            let eventType = json["Event_Type__c"].string,
            let organiserName = json["Organiser__r"]["Name"].string
            else {
                return nil
        }
        self.id = id
        self.name = name
        self.date = date
        self.registerURL = json["Event_RegisterLink__c"].string
        self.groupId = json["Directory__c"].string
        self.city = city
        self.country = json["Event_Country__c"].string ?? ""
        self.street = json["Event_Street__c"].string ?? ""
        self.postCode = json["Event_ZipCode__c"].string ?? ""
        self.photo = json["Event_Image_URL__c"].string
        self.classification = classification
        self.discountCode = json["Event_Discount_Code__c"].string
        self.quantity = json["Event_Quantity__c"].string
        self.sector = json["Event_Sector__c"].string ?? ""
        self.endDate = json["Event_End_DateTime__c"].string?.dateFromISOString()
        self.eventType = eventType
        self.organiserName = organiserName
        self.description = json["Event_Description__c"].string ?? ""
        self.visibility = json["Event_Visibility__c"].string ?? ""
        self.eventSubType = json["Event_SubType__c"].string ?? ""
        
//        companyJson["Id"] = JSON.init(stringLiteral: companyId)
//        if let company = Company(json: JSON(companyJson)) {
//            self.company = company
//        }
//        else {
//            return nil
//        }
//        self.locationName = locationName
//
//        self.logo = json["Company__r"]["Logo_Image_Url__c"].string
//        self.photo = json["Company__r"]["Banner_Image_Url__c"].string
//
//        self.relatedSDGs = json["Related_Impact_Goal__c"].string
//
//        self.applicationURL = json["Job_Application_URL__c"].string
    }
    
}

extension Event {
    var photoUrl: URL? {
        if let token = SFUserAccountManager.sharedInstance().currentUser?.credentials.accessToken,
            let photo = self.photo,
            let url = URL(string: "\(photo)?oauth_token=\(token)") {
            return url
        }
        return nil
    }
}
    
