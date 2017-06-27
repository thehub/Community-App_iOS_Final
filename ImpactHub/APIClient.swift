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

    
    func getFilters(filter: Filter.Grouping) -> Promise<[Filter]> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQueryAll("select name, Grouping__c from taxonomy__c where active__c = true and Grouping__c ='\(filter.rawValue)'", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    let items = records.flatMap { Filter(json: $0) }
                    print(items.count)
                    print(items)
                    fullfill(items)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }

    
    func getCompanies() -> Promise<String> {
        return Promise { fullfill, reject in
            
            //            let userId = SFUserAccountManager.sharedInstance().currentUser!.accountIdentity.userId
            SFRestAPI.sharedInstance().performSOQLQueryAll("SELECT name, Number_of_Employees__c, Impact_Hub_Cities__c, Sector_Industry__c, Logo_Image_Url__c, Banner_Image_Url__c from account where id in: (select accountid from contact where user__c !=: null)", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
//                    let items = records.flatMap { Member(json: $0) }
//                    print(items.count)
//                    print(items)
                    fullfill("ok")
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }

    func getGroups(contactId: String) -> Promise<String> {
        return Promise { fullfill, reject in
            print(contactId)
            SFRestAPI.sharedInstance().performSOQLQueryAll("select id, name, CountOfMembers__c, ImageURL__c, Directory_Grouping__c, Group_Desc__c, Directory_Style__c from Directory__c where Directory_Style__c = 'Project' and id in (select DirectoryID__c from Directory_Member__c where ContactID__c ='\(contactId)')", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    //                    let items = records.flatMap { Member(json: $0) }
                    fullfill("ok")
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func getProjects(contactId: String) -> Promise<String> {
        return Promise { fullfill, reject in
            print(contactId)
            SFRestAPI.sharedInstance().performSOQLQueryAll("select id, name, CountOfMembers__c, ImageURL__c, Directory_Grouping__c, Group_Desc__c, Directory_Style__c from Directory__c where Directory_Style__c ='Project' and id in: (select DirectoryID__c from Directory_Member__c where ContactID__r.id ='\(contactId)')", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    //                    let items = records.flatMap { Member(json: $0) }
                    fullfill("ok")
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func getSkills(contactId: String) -> Promise<String> {
        return Promise { fullfill, reject in
            print(contactId)
            SFRestAPI.sharedInstance().performSOQLQueryAll("select id,name,Contact__c,Contact__r.id,Skill_Description__c from Contact_Skills__c where Contact__r.id ='\(contactId)'", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
//                    let items = records.flatMap { Member(json: $0) }
                    fullfill("ok")
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func getMembers() -> Promise<[Member]> {
        return Promise { fullfill, reject in
            
//            let userId = SFUserAccountManager.sharedInstance().currentUser!.accountIdentity.userId
            SFRestAPI.sharedInstance().performSOQLQueryAll("SELECT id,firstname,lastname,ProfilePic__c, Profession__c,Impact_Hub_Cities__c,User__c,About_Me__c FROM Contact where User__c != null", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    let items = records.flatMap { Member(json: $0) }
                    print(items.count)
                    print(items)
                    fullfill(items)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    
    func getContact(userId:String) -> Promise<Contact> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQueryAll("SELECT id,FirstName,LastName,Email,ProfilePic__c,User__c,About_Me__c,Profession__c,Taxonomy__c,Skills__c FROM Contact where User__c = '\(userId)'", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    let items = records.flatMap { Contact(json: $0) }
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
    
    func getContacts(contactIds:[String]) -> Promise<[Contact]> {
        return Promise { fullfill, reject in
            
            let contactIdsString = contactIds.map({"'\($0)'"}).joined(separator: ",")
            //            let userAccount = SFUserAccountManager.sharedInstance().currentUser!.accountIdentity
            SFRestAPI.sharedInstance().performSOQLQueryAll("SELECT id,FirstName,LastName,Email,ProfilePic__c,User__c,About_Me__c,Profession__c,Taxonomy__c,Skills__c FROM Contact where id in (\(contactIdsString))", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    let items = records.flatMap { Contact(json: $0) }
                    fullfill(items)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func sendMessage(message: String, members: [Contact]?, inReplyTo: String?) -> Promise<Message> {
        return Promise { fullfill, reject in
            var query: [String: AnyObject]!
            if let members = members {
                let recipients = members.flatMap({$0.userId}) //.joined(separator: ",")
                query = ["body": message as AnyObject, "recipients" : recipients as AnyObject]
            }
            else if let inReplyTo = inReplyTo {
                query = ["body": message as AnyObject, "inReplyTo" : inReplyTo as AnyObject]
            }
            else {
                reject(MyError.Error("Error"))
                return
            }
            
            let body = SFJsonUtils.jsonDataRepresentation(query)
            
            let request = SFRestRequest(method: .POST, path: "/services/data/v39.0/connect/communities/\(Constants.communityId)/chatter/users/me/messages/", queryParams: nil)
            
            request.setCustomRequestBodyData(body!, contentType: "application/json")
            request.setHeaderValue("\(u_long(body?.count ?? 0))", forHeaderName: "Content-Length")
            
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                print(error?.localizedDescription as Any)
                reject(error ?? MyError.Error("Error"))
            }) { (result) in
                if let result = result as? [String: Any], let message = Message(json: result) {
                    fullfill(message)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func getConversations() -> Promise<[Conversation]> {
        return Promise { fullfill, reject in
            let query: [String: String] = ["filterGroup" : "Small"]
            let request = SFRestRequest(method: .GET, path: "/services/data/v39.0/connect/communities/\(Constants.communityId)/chatter/users/me/conversations", queryParams: query)
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                print(error?.localizedDescription as Any)
                reject(error ?? MyError.Error("Error"))
            }) { (result) in
                if let json = (result as AnyObject)["conversations"] as? [[String: Any]] {
                    let conversations = json.flatMap { Conversation(json: $0) }
                    fullfill(conversations)
                }
                else {
                    reject(MyError.JSONError)
                }
                
            }
        }
    }
    
    func getMessagesForConversation(conversationId: String) -> Promise<[Message]> {
        return Promise { fullfill, reject in
            let query: [String: String] = ["filterGroup" : "Small"]
            let request = SFRestRequest(method: .GET, path: "/services/data/v39.0/connect/communities/\(Constants.communityId)/chatter/users/me/conversations/\(conversationId)", queryParams: query)
            
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                print(error?.localizedDescription as Any)
                reject(error ?? MyError.Error("Error"))
            }) { (result) in
                if let jsonCollection = (result as AnyObject)["messages"] as? [String: Any], let json = jsonCollection["messages"] as? [[String : Any]] {
                    let messages = json.flatMap { Message(json: $0) }
                    fullfill(messages)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func markConversationAsRead(conversationId: String) -> Promise<Bool> {
        return Promise { fullfill, reject in
            let query: [String: Any] = ["read" : "true"]
            
            let request = SFRestRequest(method: .PATCH, path: "/services/data/v39.0/connect/communities/\(Constants.communityId)/chatter/users/me/conversations/\(conversationId)", queryParams: query)
            
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                print(error?.localizedDescription as Any)
                reject(error ?? MyError.Error("Error"))
            }) { (result) in
                debugPrint(result as Any)
                if let read = (result as AnyObject)["read"] as? Bool {
                    fullfill(read)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    


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
