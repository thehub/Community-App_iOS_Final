//
//  ContactRequestManager.swift
//  ImpactHub
//
//  Created by Niklas on 13/07/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation
import PromiseKit


class ContactRequestManager {
    
    var contactRequests = [DMRequest]()
    
    func allowedToMessage(userId: String) -> Bool {
        // Check if it's in the contacts
        if self.getConnectedContactRequests().filter({$0.userToId == userId || $0.userFromId == userId}).first == nil {
            return false
        }
        else {
            return true
        }
    }
    
    
    func getRelevantContactRequestFor(member: Member) -> DMRequest? {
        let contactRequest = contactRequests.filter({ $0.contactFromId == member.contactId || $0.contactToId == member.contactId }).first
        return contactRequest
    }
    
    
    func getConnectedContactRequests() -> [DMRequest] {
        let connectedContactRequests = ContactRequestManager.shared.contactRequests.filter({$0.status == .approved})
        return connectedContactRequests
    }

    func getIncommingContactRequests() -> [DMRequest] {
        let connectedContactRequests = ContactRequestManager.shared.contactRequests.filter({$0.status == .approveDecline })
        return connectedContactRequests
    }

    func getAwaitingContactRequests() -> [DMRequest] {
        let connectedContactRequests = ContactRequestManager.shared.contactRequests.filter({$0.status == .outstanding })
        return connectedContactRequests
    }

    func getDeclinedContactRequests() -> [DMRequest] {
        let connectedContactRequests = ContactRequestManager.shared.contactRequests.filter({$0.status == .declined })
        return connectedContactRequests
    }

    
    func refresh() -> Promise<[DMRequest]> {
        return Promise { fullfill, reject in
            firstly {
                APIClient.shared.getDMRequests()
                }.then { contactRequests -> Void in
                    ContactRequestManager.shared.contactRequests = contactRequests
                    fullfill(contactRequests)
                }.always {
                }.catch { error in
                    debugPrint(error.localizedDescription)
                    reject(MyError.Error("regresh failed"))
            }
        }
    }
    
    
    
    
    
    
    static let shared = ContactRequestManager()

}
