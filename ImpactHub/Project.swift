//
//  Project.swift
//  ImpactHub
//
//  Created by Niklas on 19/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation

struct Project {
    
    var name: String
    var objectives: [Project.Objective] {
        get {
            let objective1 = Objective(number: 1, title: "Objective", description: "Lorem ipsum dolor sit amet, consectetur adipiscing eli Lorem ipsum dolor sit amet, consectetur adipiscing eli Lorem ipsum dolor sit amet, consectetur adipiscing eli Lorem ipsum dolor sit amet, consectetur adipiscing eli.", isLast: false)
            let objective2 = Objective(number: 2, title: "Objective", description: "Lorem ipsum dolor sit amet, consectetur adipiscing eli Lorem ipsum dolor sit amet, consectetur adipiscing eli Lorem ipsum dolor sit amet, consectetur adipiscing eli Lorem ipsum dolor sit amet, consectetur adipiscing eli.", isLast: false)
            let objective3 = Objective(number: 3, title: "Objective", description: "Lorem ipsum dolor sit amet, consectetur adipiscing eli Lorem ipsum dolor sit amet, consectetur adipiscing eli Lorem ipsum dolor sit amet, consectetur adipiscing eli Lorem ipsum dolor sit amet, consectetur adipiscing eli.", isLast: false)
            let objective4 = Objective(number: 4, title: "Objective", description: "Lorem ipsum dolor sit amet, consectetur adipiscing eli Lorem ipsum dolor sit amet, consectetur adipiscing eli Lorem ipsum dolor sit amet, consectetur adipiscing eli Lorem ipsum dolor sit amet, consectetur adipiscing eli.", isLast: true)

            return [objective1, objective2, objective3, objective4]
        }
    }
    
    
    struct Objective {
        var number: Int
        var title: String
        var description: String
        var isLast: Bool
    }
    
}
