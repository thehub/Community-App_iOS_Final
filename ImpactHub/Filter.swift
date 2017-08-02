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
        case skill
        case sdg
        case jobType
        
        var displayName: String {
            get {
                switch self {
                case .city:
                    return "City"
                case .sector:
                    return "Sector"
                case .skill:
                    return "Skill"
                case .sdg:
                    return "Goal"
                case .jobType:
                    return "Type"
                }
            }
        }
    }
    
    init(grouping: Grouping, name: String) {
        self.grouping = grouping
        self.name = name
    }
    
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

extension Filter: Equatable {

    static func ==(lhs: Filter, rhs: Filter) -> Bool {
        return lhs.grouping == rhs.grouping && lhs.name == rhs.name
    }
    
}


