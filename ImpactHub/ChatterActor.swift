//
//  ChatterActor.swift
//  MembershipApp
//
//  Created by Niklas Alvaeus on 16/02/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation
import SalesforceSDKCore

struct ChatterActor {
    
    var id: String
    var communityNickname: String?
    var companyName: String?
    var displayName: String?
    var firstName: String?
    var lastName: String?
    internal var profilePicLarge: String?
    internal var profilePicMedium: String?
    internal var profilePicSmall: String?
    var title: String?

    var name: String {
        return "\(firstName ?? "") \(lastName ?? "")"
    }

}

extension ChatterActor {
    var profilePicLargeUrl: URL? {
        if let token = SFUserAccountManager.sharedInstance().currentUser?.credentials.accessToken,
            let profilePic = self.profilePicLarge,
            let url = URL(string: "\(profilePic)?oauth_token=\(token)") {
            return url
        }
        return nil
    }

    var profilePicMediumUrl: URL? {
        if let token = SFUserAccountManager.sharedInstance().currentUser?.credentials.accessToken,
            let profilePic = self.profilePicMedium,
            let url = URL(string: "\(profilePic)?oauth_token=\(token)") {
            return url
        }
        return nil
    }

    var profilePicSmallUrl: URL? {
        if let token = SFUserAccountManager.sharedInstance().currentUser?.credentials.accessToken,
            let profilePic = self.profilePicSmall,
            let url = URL(string: "\(profilePic)?oauth_token=\(token)") {
            return url
        }
        return nil
    }

}

extension ChatterActor {
    
    init?(json: [AnyHashable: Any]) {
        print(json)
        guard let userJson = json["user"] as? [AnyHashable: Any] else {
            return nil
        }
        
        if let id = userJson["id"] as? String {
            self.id = id
        }
        else {
            return nil
        }
        
        if let photo = userJson["photo"] as? [String: Any] {
            if let profilePicLarge = photo["largePhotoUrl"] as? String {
                self.profilePicLarge = profilePicLarge
            }
            if let profilePicMedium = photo["mediumPhotoUrl"] as? String {
                self.profilePicMedium = profilePicMedium
            }
            if let profilePicSmall = photo["smallPhotoUrl"] as? String {
                self.profilePicSmall = profilePicSmall
            }
        }
        
        if let firstName = userJson["firstName"] as? String {
            self.firstName = firstName
        }
        
        if let lastName = userJson["lastName"] as? String {
            self.lastName = lastName
        }

        if let communityNickname = userJson["communityNickname"] as? String {
            self.communityNickname = communityNickname
        }

        if let displayName = userJson["displayName"] as? String {
            self.displayName = displayName
        }

        if let title = userJson["title"] as? String, title != "<null>" {
            self.title = title
        }

        if let companyName = userJson["companyName"] as? String, companyName != "<null>" {
            self.companyName = companyName
        }
    }

    init?(userJson: [AnyHashable: Any]) {
//        print(userJson)
        if let id = userJson["id"] as? String {
            self.id = id
        }
        else {
            return nil
        }
        
        if let photo = userJson["photo"] as? [String: Any] {
            if let profilePicLarge = photo["largePhotoUrl"] as? String {
                self.profilePicLarge = profilePicLarge
            }
            if let profilePicMedium = photo["mediumPhotoUrl"] as? String {
                self.profilePicMedium = profilePicMedium
            }
            if let profilePicSmall = photo["smallPhotoUrl"] as? String {
                self.profilePicSmall = profilePicSmall
            }
        }
        
        if let firstName = userJson["firstName"] as? String {
            self.firstName = firstName
        }
        
        if let lastName = userJson["lastName"] as? String {
            self.lastName = lastName
        }
        
        if let communityNickname = userJson["communityNickname"] as? String {
            self.communityNickname = communityNickname
        }
        
        if let displayName = userJson["displayName"] as? String {
            self.displayName = displayName
        }
        
        if let title = userJson["title"] as? String, title != "<null>" {
            self.title = title
        }
        
        if let companyName = userJson["companyName"] as? String, companyName != "<null>" {
            self.companyName = companyName
        }
        
        
    }
    
    
}
