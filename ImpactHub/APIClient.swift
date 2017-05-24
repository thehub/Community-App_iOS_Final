//
//  APIClient.swift
//  ImpactHub
//
//  Created by Niklas on 24/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import Foundation
import UIKit
import SalesforceSDKCore
import PromiseKit
import SwiftyJSON

class APIClient {


    func getJobs(skip:Int, top:Int) -> Promise<[Job]> {
        return Promise { fullfill, reject in
            // TODO: Send in pagination
            SFRestAPI.sharedInstance().performSOQLQueryAll("SELECT Id,Name,Description__c,Contact__c,Contact__r.FirstName,Contact__r.LastName,Type__c,Age__c,Contact__r.AccountId,Contact__r.Account.Name FROM Job__c", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.Error("Error"))
            }) { (result) in
                let jsonResult = JSON(result!)
                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    let items = records.flatMap { Job(json: $0) }
                    fullfill(items)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func getCompany(companyId:String) -> Promise<Company> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQueryAll("SELECT id,Name, website FROM Account where id = '\(companyId)'", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    let items = records.flatMap { Company(json: $0) }
                    if let item = items.first {
                        fullfill(item)
                    }
                    else {
                        reject(MyError.JSONError)
                    }
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    static let shared = APIClient()

}
