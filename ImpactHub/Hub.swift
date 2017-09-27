//
//  Hub.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 26/09/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON
import SalesforceSDKCore

struct Hub {
    var id: String
    var name: String
}

extension Hub {
    init?(json: JSON) {
        guard
            let id = json["Id"].string,
            let name = json["Name"].string
            else {
                return nil
        }
        self.id = id
        self.name = name
    }
}


