//
//  Filter.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 27/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Filter {
    var grouping: Grouping
    var name: String
    
    enum Grouping : String {
        case city
        case sector
    }
}

extension Filter {
    init?(json: JSON) {
        guard
            let grouping = json["Grouping__c"].string,
            let name = json["Name"].string
            else {
                return nil
        }
        if let grouping = Grouping(rawValue: grouping.lowercased()) {
            self.grouping = grouping
        }
        else {
            return nil
        }
        self.name = name
    }
    
}
