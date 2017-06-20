//
//  Job.swift
//  MembershipApp
//
//  Created by Niklas on 24/04/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON


struct Job {
    var id: String
    var name: String
    var company: Company
    var description: String
    var locationName: String
    var type: String
    var salary: String
    var companyName: String
    var companyId: String
    
}

extension Job {
    init?(json: JSON) {
        debugPrint(json)
        guard
            let id = json["Id"].string,
            let description = json["Description__c"].string,
            let name = json["Name"].string,
            let type = json["Type__c"].string,
            let companyName = json["Contact__r"]["Account"]["Name"].string,
            let companyId = json["Contact__r"]["AccountId"].string
            else {
                return nil
        }
        self.id = id
        self.description = description
        self.name = name
        self.type = type
        self.companyName = companyName
        self.companyId = companyId
        
        self.salary = ""
        self.company = Company(id: "asdsad", name: "Test Compnay", type: "sdsdf", photo: "sdfdsf", blurb: "sdfdsfsdf", locationName: "sdfdsfs", website: "http://www.dn.se", size: "10 - 30")
        self.locationName = "London"
    }
    
}
