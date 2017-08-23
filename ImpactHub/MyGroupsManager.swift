//
//  MyGroupsManager.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 23/08/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation
import PromiseKit


class MyGroupsManager {
    
    var groupIds = [String]()
    
    func isInGroup(groupId:String) -> Bool {
        return groupIds.contains(groupId)
    }
    
    func refresh() -> Promise<[String]> {
        return Promise { fullfill, reject in
            firstly {
                APIClient.shared.getMyGroups()
                }.then { groupIds -> Void in
                    MyGroupsManager.shared.groupIds = groupIds
                    fullfill(groupIds)
                }.always {
                }.catch { error in
                    debugPrint(error.localizedDescription)
                    reject(MyError.Error("MyGroupsManager refresh failed"))
            }
        }
    }
    
    
    
    static let shared = MyGroupsManager()
    
}
