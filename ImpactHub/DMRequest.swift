//
//  DMRequest.swift
//  MembershipApp
//
//  Created by Niklas on 08/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DMRequest {
    var id: String
    var name: String
    var status: DMRequest.Satus
    var createdDate: Date
    var contactFromId: String
    var contactToId: String
    
    enum Satus: String {
        case Outstanding
        case Approved
        case Declined
    }
    
    func displayLabel() -> String {
        switch status {
        case .Approved:
            return "Contact"
        case .Outstanding:
            if contactToId == Model.shared.me?.contactId {
                return "Accept"
            }
            else {
                return "Awaiting Response"
            }
        case .Declined:
            return "Declined"
        }
    }

    
}

extension DMRequest {
    init?(json: JSON) {
        guard
            let id = json["Id"].string,
            let name = json["Name"].string,
            let createdDate = json["CreatedDate"].string?.dateFromISOString(),
            let statusString = json["Status__c"].string,
            let status = DMRequest.Satus.init(rawValue: statusString),
            let contactFromId = json["ContactFrom__c"].string,
            let contactToId = json["ContactTo__c"].string
            else {
                return nil
        }
        self.id = id
        self.name = name
        self.status = status
        self.createdDate = createdDate
        self.contactFromId = contactFromId
        self.contactToId = contactToId
    }
}
