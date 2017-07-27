//
//  User.swift
//  MembershipApp
//
//  Created by Niklas on 21/03/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation

struct User {
    var id: String
    var companyName: String?
    var displayName: String
    var firstName: String?
    var lastName: String?
    var mySubscription: Reference?
    var photo: Photo?
    var title: String?
    
    var name: String {
        return "\(firstName) \(lastName)"
    }
    
}

extension User {
    init?(json: [String: Any]) {
//        debugPrint(json)
        guard
            let id = json["id"] as? String,
            let displayName = json["displayName"] as? String
            else {
                return nil
        }
        
        self.id = id
        if let companyName = json["companyName"] as? String {
            self.companyName = companyName
        }
        
        self.displayName = displayName

        
        if let firstName = json["firstName"] as? String {
            self.firstName = firstName
        }
        if let lastName = json["lastName"] as? String {
            self.lastName = lastName
        }
        
        if let title = json["title"] as? String {
            self.title = title
        }


        if let mySubscriptionJson = json["mySubscription"] as? [String : Any] {
            if let mySubscription = Reference(json: mySubscriptionJson) {
                self.mySubscription = mySubscription
            }
        }

        if let photoJson = json["photo"] as? [String : Any] {
            if let photo = Photo(json: photoJson) {
                self.photo = photo
            }
        }
        
        
        
        
    }
    
}
