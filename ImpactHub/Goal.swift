//
//  Project.swift
//  ImpactHub
//
//  Created by Niklas on 19/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON
import SalesforceSDKCore

struct Goal {
    var id: String
    var name: String
    var nameId: String
    var summary: String
    var photo: String = "goalPhoto" // TODO
    
}

extension Goal {
    init?(json: JSON) {
        guard
            let id = json["Id"].string,
            let name = json["Goal__c"].string,
            let nameId = json["Name"].string,
            let summary = json["Goal_Summary__c"].string
            else {
                return nil
        }
        self.id = id
        self.summary = summary
        self.name = name
        self.nameId = nameId

//        self.logo = json["Company__r"]["Logo_Image_Url__c"].string
//        self.photo = json["Company__r"]["Banner_Image_Url__c"].string
        
    }
    
}

