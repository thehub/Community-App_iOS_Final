//
//  Constants.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation
import UIKit
import SalesforceSDKCore

enum MyError : Error {
    case Error(String)
    case JSONError
}

struct Constants {

    // Dev
    static let host = "https://lightful-impacthub.cs88.force.com"
    static var communityId : String {
        get {
            return SFUserAccountManager.sharedInstance().currentUser!.communityId!
        }
    }
    
}


