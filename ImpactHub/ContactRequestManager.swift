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
        print(contactRequest?.status)
        return contactRequest
    }
    
    
    func getConnectedContactRequests() -> [DMRequest] {
        let connectedContactRequests = ContactRequestManager.shared.contactRequests.filter({$0.status == .Approved})
        if connectedContactRequests != nil {
            return connectedContactRequests
        }
        else {
            return [DMRequest]()
        }
    }

    func getIncommingContactRequests() -> [DMRequest] {
        let connectedContactRequests = ContactRequestManager.shared.contactRequests.filter({$0.status == .Outstanding && $0.contactToId == SessionManager.shared.me?.id ?? "" })
        if connectedContactRequests != nil {
            return connectedContactRequests
        }
        else {
            return [DMRequest]()
        }
    }

    func getAwaitingContactRequests() -> [DMRequest] {
        let connectedContactRequests = ContactRequestManager.shared.contactRequests.filter({$0.status == .Outstanding && $0.contactFromId == SessionManager.shared.me?.id ?? "" })
        if connectedContactRequests != nil {
            return connectedContactRequests
        }
        else {
            return [DMRequest]()
        }
    }
    
    static let shared = ContactRequestManager()

}
