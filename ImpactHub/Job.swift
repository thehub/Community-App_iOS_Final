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
    
}

//extension Job {
//    init?(json: JSON) {
//        debugPrint(json)
//        guard
//            let id = json["Id"].string,
//            let description = json["Description__c"].string,
//            let name = json["Name"].string
//            else {
//                return nil
//        }
//        self.id = id
//        self.description = description
//        self.name = name
//    }
//    
//}
