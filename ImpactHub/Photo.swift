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
    var largePhotoUrl: URL?
    var mediumPhotoUrl: URL?
    var smallPhotoUrl: URL?
    
}

extension Photo {
    init?(json: [String: Any]) {
//        print(json)
        guard
            let standardEmailPhotoUrl = json["standardEmailPhotoUrl"] as? String,
            let mediumPhotoUrl = json["mediumPhotoUrl"] as? String,
            let smallPhotoUrl = json["smallPhotoUrl"] as? String
            else {
                return nil
        }
        self.standardEmailPhotoUrl = standardEmailPhotoUrl

        if let largePhotoUrl = json["largePhotoUrl"] as? String {
            self.largePhotoUrl = URL(string: largePhotoUrl)
        }
        
        self.mediumPhotoUrl = URL(string: mediumPhotoUrl)
        self.smallPhotoUrl = URL(string: smallPhotoUrl)
    }
}
