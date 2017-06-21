//
//  Company.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 19/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Company {
    var id: String
    var name: String
    var type: String
    var photo: String
    var logo: String
    var blurb: String
    var locationName: String
    var website: String?
    var size: String

}

extension Company {
    init?(json: JSON) {
        debugPrint(json)
        guard
            let id = json["Id"].string,
            let name = json["Name"].string
            else {
                return nil
        }
        self.id = id
        self.name = name
        
        self.type = "Full-time"
        self.photo = ""
        self.logo = "" //TODO:
        self.blurb = "sddsfsd"
        self.locationName = "Amsterdam"
        self.website = json["Website"].string
        self.size = "10 - 20" // TODO: Set this form json
    }
    
}
