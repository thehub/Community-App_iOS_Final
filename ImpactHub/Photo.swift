//
//  Photo.swift
//  MembershipApp
//
//  Created by Niklas on 21/03/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation

struct Photo {
    var standardEmailPhotoUrl: String
    var largePhotoUrl: String?
    var mediumPhotoUrl: String
    var smallPhotoUrl: String
    
}

extension Photo {
    init?(json: [String: Any]) {
        guard
            let standardEmailPhotoUrl = json["standardEmailPhotoUrl"] as? String,
            let mediumPhotoUrl = json["mediumPhotoUrl"] as? String,
            let smallPhotoUrl = json["smallPhotoUrl"] as? String
            else {
                return nil
        }
        self.standardEmailPhotoUrl = standardEmailPhotoUrl

        if let largePhotoUrl = json["largePhotoUrl"] as? String {
            self.largePhotoUrl = largePhotoUrl
        }
        
        self.mediumPhotoUrl = mediumPhotoUrl
        self.smallPhotoUrl = smallPhotoUrl
    }
}
