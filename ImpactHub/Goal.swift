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
    var summary: String = ""
    var description: String?
    var photo: String?
}

extension Goal {
    init?(json: JSON) {
        guard
            let id = json["Id"].string,
            let name = json["Name"].string
            else {
                return nil
        }
        self.id = id
        self.summary = json["Summary__c"].string ?? ""
        self.name = name
        self.description = json["Description__c"].string
        self.photo = json["ImageURL__c"].string
        
    }
    
}

extension Goal {
    var photoUrl: URL? {
        if let token = SFUserAccountManager.sharedInstance().currentUser?.credentials.accessToken,
            let photo = self.photo,
            let url = URL(string: "\(photo)?oauth_token=\(token)") {
            return url
        }
        return nil
    }

}

