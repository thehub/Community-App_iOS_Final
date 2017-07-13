//
//  ContactRequestManager.swift
//  ImpactHub
//
//  Created by Niklas on 13/07/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation


class ContactRequestManager {
    
    var contactRequests = [DMRequest]()
    
    func getRelevantContactRequestFor(member: Member) -> DMRequest? {
        let contactRequest = contactRequests.filter({ $0.contactFromId == member.id || $0.contactToId == member.id }).first
        return contactRequest
    }
    
    
    static let shared = ContactRequestManager()

}
