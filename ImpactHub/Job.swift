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
    var companyId: String
    var description: String = ""
    var sector: String?
    var locationName: String
    var type: String
    var salary: String
    var companyName: String
    
}

extension Job {
    init?(json: JSON) {
        debugPrint(json)
        guard
            let id = json["Id"].string,
            let name = json["Name"].string,
            let type = json["Job_Type__c"].string,
            let companyName = json["Company__r"]["Name"].string,
            let companyId = json["Company__c"].string,
            let salary = json["Salary__c"].string
            else {
                return nil
        }
        self.id = id
        self.description = json["Description__c"].string ?? ""
        self.sector = json["Sector__c"].string
        self.name = name
        self.type = type
        self.salary = salary
        self.companyName = companyName
        self.companyId = companyId
        self.company = Company(id: "asdsad", name: "Test Compnay", type: "sdsdf", photo: "sdfdsf", logo:"companyLogo", blurb: "sdfdsfsdf", locationName: "sdfdsfs", website: "http://www.dn.se", size: "10 - 30")
        self.locationName = "London"
    }
    
}
