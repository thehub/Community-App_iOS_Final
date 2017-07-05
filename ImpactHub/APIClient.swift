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

    
    func getProjects() -> Promise<[Project]> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQueryAll("select id, name,Related_Impact_Goal__c,ChatterGroupId__c ,Group_Desc__c, ImageURL__c, Directory_Style__c, Organisation__r.id, Organisation__r.Number_of_Employees__c, Organisation__r.Impact_Hub_Cities__c, Organisation__r.name from Directory__c where Directory_Style__c = 'Project'", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    let items = records.flatMap { Project(json: $0) }
                    fullfill(items)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func getObjectives(projectId: String) -> Promise<[Project.Objective]> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQueryAll("SELECT Directory__c,Goal_Summary__c,Goal__c,Id,Name FROM Directory_Goal__c where Directory__c='\(projectId)'", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    var items = records.flatMap { Project.Objective(json: $0) }
                    if items.count > 0 {
                        // Set ordering so they can be rendered correctly
                        for index in 0..<items.count {
                            items[index].setNumber(number: index + 1)
                        }
                        items[items.count - 1].setIsLast(isLast: true)
                    }
                    fullfill(items)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func getMembers(projectId: String) -> Promise<[Member]> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQueryAll("SELECT id, firstname,lastname, ProfilePic__c, accountid,Profession__c, Impact_Hub_Cities__c, User__c, About_Me__c FROM Contact WHERE id in (SELECT contactID__c FROM Directory_Member__c where DirectoryID__c='\(projectId)')", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    let items = records.flatMap { Member(json: $0) }
                    fullfill(items)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    
//    SELECT Applications_Close_Date__c,Company__c,Contact__c,Description__c,Id,Job_Age_in_Days__c,Job_Type__c,Location__c,Project__c,Related_Impact_Goal__c,Salary__c,Sector__c FROM Job__c
//    
//    [1:14]
//    Job_Type__c => Full Time/Part Time
//    
//    [1:15]
//    Salary__c
//    
//    [1:15] 
//    Description__c
    

    func getJobs(projectId: String) -> Promise<[Job]> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQueryAll("select id, name, Description__c, Salary__c,Job_Type__c, Company__c, Company__r.name, Company__r.Logo_Image_Url__c,Sector__c,Contact__c, Location__c, Applications_Close_Date__c from Job__c where Project__r.id='\(projectId)'", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
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
    
    func getFilters(grouping: Filter.Grouping) -> Promise<[Filter]> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQueryAll("select name, Grouping__c from taxonomy__c where active__c = true and Grouping__c ='\(grouping.rawValue)'", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
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

    
    func getCompanies() -> Promise<[Company]> {
        return Promise { fullfill, reject in
            
            SFRestAPI.sharedInstance().performSOQLQueryAll("SELECT id, name, Number_of_Employees__c, Impact_Hub_Cities__c, Sector_Industry__c, Logo_Image_Url__c, Banner_Image_Url__c, Twitter__c, Instagram__c, Facebook__c, LinkedIn__c , Website, About_Us__c from account where id in (select accountid from contact where user__c != null)", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
//                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    let items = records.flatMap { Company(json: $0) }
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
            SFRestAPI.sharedInstance().performSOQLQueryAll("SELECT id, name, Number_of_Employees__c, Impact_Hub_Cities__c, Sector_Industry__c, Logo_Image_Url__c, Banner_Image_Url__c, Twitter__c, Instagram__c, Facebook__c, LinkedIn__c , Website, About_Us__c from account where id = '\(companyId)'", fail: { (error) in
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
    
    func getCompanyServices(companyId: String) -> Promise<[Company.Service]> {
        return Promise { fullfill, reject in
            
            SFRestAPI.sharedInstance().performSOQLQueryAll("select id, name, Service_Description__c from Company_Service__c where Company__r.id ='\(companyId)'", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    let items = records.flatMap { Company.Service(json: $0) }
                    fullfill(items)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }

    func getGroups(contactId: String) -> Promise<[Group]> {
        return Promise { fullfill, reject in
            print(contactId)
            SFRestAPI.sharedInstance().performSOQLQueryAll("select id, name, CountOfMembers__c, ImageURL__c, Group_Desc__c, Impact_Hub_Cities__c, ChatterGroupId__c from Directory__c where Directory_Style__c = 'Group' and id in (select DirectoryID__c from Directory_Member__c where ContactID__c ='\(contactId)')", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
                if let records = jsonResult["records"].array {
                    let items = records.flatMap { Group(json: $0) }
                    fullfill(items)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func getProjects(contactId: String) -> Promise<[Project]> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQueryAll("select id,ChatterGroupId__c, name, CountOfMembers__c, ImageURL__c, Group_Desc__c, Organisation__r.Name, Organisation__c, Impact_Hub_Cities__c from Directory__c where Directory_Style__c ='Project' and id in (select DirectoryID__c from Directory_Member__c where ContactID__c ='\(contactId)')", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    let items = records.flatMap { Project(json: $0) }
                    fullfill(items)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func getProjects(companyId: String) -> Promise<[Project]> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQueryAll("select id,ChatterGroupId__c, name, CountOfMembers__c, ImageURL__c, Group_Desc__c, Organisation__r.Name, Organisation__c, Impact_Hub_Cities__c from Directory__c where Directory_Style__c ='Project' and Organisation__c ='\(companyId)'", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    let items = records.flatMap { Project(json: $0) }
                    fullfill(items)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func getSkills(contactId: String) -> Promise<[Member.Skill]> {
        return Promise { fullfill, reject in
            print(contactId)
            SFRestAPI.sharedInstance().performSOQLQueryAll("select id,name,Skill_Description__c from Contact_Skills__c where Contact__r.id ='\(contactId)'", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    let items = records.flatMap { Member.Skill(json: $0) }
                    fullfill(items)
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
            SFRestAPI.sharedInstance().performSOQLQueryAll("select id, name, Company__c, Company__r.name, Company__r. Logo_Image_Url__c, Location__c, Applications_Close_Date__c from Job__c where Applications_Close_Date__c >= system.today()", fail: { (error) in
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
    

    
    
    
    
    
    
    
    
    
    
    
    // Chatter stuff
    func loadComments(nextPageUrl: String) -> Promise<[Comment]> {
        return Promise { fullfill, reject in
            let query: [String: String] = ["filterGroup" : "Medium"]
            let request = SFRestRequest(method: .GET, path: nextPageUrl, queryParams: query)
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                print(error?.localizedDescription as Any)
                reject(MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON.init(result!)
                debugPrint(jsonResult)
                let items = jsonResult["items"].arrayValue.flatMap { Comment(json: $0) }
                fullfill(items)
            }
        }
    }
    
    func getGroupPosts(groupID: String) -> Promise<[Post]> {
        return Promise { fullfill, reject in
            let query: [String: String] = ["filterGroup" : "Medium"]
            let request = SFRestRequest(method: .GET, path: "/services/data/v39.0/connect/communities/\(Constants.communityId)/chatter/feeds/record/\(groupID)/feed-elements", queryParams: query)
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                print(error?.localizedDescription as Any)
                reject(MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON.init(result!)
                print(jsonResult)

                if let json = jsonResult["elements"].array {
                    let items = json.flatMap { Post(json: $0) }
                    fullfill(items)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func uploadImage(imageData: Data) -> Promise<String> {

        return Promise { fullfill, reject in
            let uid = UUID().uuidString
            let request = SFRestAPI.sharedInstance().request(forUploadFile: imageData, name: "\(uid).jpg", description: "Desc", mimeType: "image/jpeg")
            request.path = "/v36.0/connect/communities/\(Constants.communityId)/files/users/me"
            //        print(request.path)
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                    reject(MyError.JSONError)
                }
            }) { (result) in
                if let id = (result as AnyObject)["id"] as? String {
                    fullfill(id)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func postToGroup(groupID: String, messageSegments: [[String: String]], fileId:String?) -> Promise<Post> {
        return Promise { fullfill, reject in
            var query: JSON!
            print(messageSegments)
            if let fileId = fileId {
                query = ["body" : ["messageSegments" : messageSegments], "feedElementType": "FeedItem", "subjectId": groupID, "capabilities": ["files": ["items": ["id": fileId]]]]
            }
            else {
                query = ["body" : ["messageSegments" : messageSegments], "feedElementType": "FeedItem", "subjectId": groupID]
            }
            
            let body = SFJsonUtils.jsonDataRepresentation(query.dictionaryObject)
            let request = SFRestRequest(method: .POST, path: "/services/data/v39.0/connect/communities/\(Constants.communityId)/chatter/feed-elements", queryParams: nil)
            request.setCustomRequestBodyData(body!, contentType: "application/json")
            request.setHeaderValue("\(u_long(body?.count ?? 0))", forHeaderName: "Content-Length")
            
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                print(error?.localizedDescription as Any)
                reject(MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
                if let post = Post(json: jsonResult) {
                    fullfill(post)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func postComment(newsID: String, message: String) -> Promise<Comment> {
        return Promise { fullfill, reject in
            let query = "{\"body\": {\"messageSegments\": [{\"type\": \"Text\", \"text\": \"\(message)\"}]}}"
            let request = SFRestRequest(method: .POST, path: "/services/data/v39.0/connect/communities/\(Constants.communityId)/chatter/feed-elements/\(newsID)/capabilities/comments/items", queryParams: nil)
            request.setCustomRequestBodyString(query, contentType: "application/json")
            request.setHeaderValue("\(u_long(query.characters.count))", forHeaderName: "Content-Length")
            
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                print(error?.localizedDescription as Any)
                reject(MyError.JSONError)
            }) { (result) in
                if let comment = Comment(json: JSON(result)) {
                    fullfill(comment)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func likePost(post: Post) -> Promise<String> {
        return Promise { fullfill, reject in

            let request = SFRestRequest(method: .POST, path: "/services/data/v40.0/connect/communities/\(Constants.communityId)/chatter/feed-elements/\(post.id!)/capabilities/chatter-likes/items?include=/id", queryParams: nil)
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                print(error?.localizedDescription as Any)
                reject(MyError.JSONError)
            }) { (result) in
                if let result = result {
                    // Return myLikeId
                    if let myLikeId = JSON(result)["id"].string {
                        fullfill(myLikeId)
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
    
    func unlikePost(post: Post) -> Promise<String> {
        return Promise { fullfill, reject in
            
            if let myLikeId = post.myLikeId {
                let request = SFRestRequest(method: .DELETE, path: "/services/data/v40.0/connect/communities/\(Constants.communityId)/chatter/likes/\(myLikeId)", queryParams: nil)
                SFRestAPI.sharedInstance().send(request, fail: { (error) in
                    print(error?.localizedDescription as Any)
                    reject(MyError.JSONError)
                }) { (result) in
                    debugPrint(result)
                    fullfill("ok")
                }
            }
            else {
                print("ERROR: No myLikeId")
                reject(MyError.Error("No myLikeId"))
            }

        }
    }
    
    
    
    // Mentions
//    func getValidMentionCompletions(parentId: String) -> Promise<[MentionCompletion]> {
//        return Promise { fullfill, reject in
//            firstly {
//                self.getMentionCompletions()
//                }.then { items -> Void in
//                    self.getMentionValidations(parentId: parentId, mentionCompletions: items)
//                }.then { validItems -> Void in
//                    fullfill(validItems)
//                }.catch { error in
//                    debugPrint(error.localizedDescription)
//                    reject(MyError.Error("Could not get mention completions"))
//            }
//        }
//    }
    
    func getMentionCompletions() -> Promise<[MentionCompletion]> {
        return Promise { fullfill, reject in
            let query: [String: String] = ["filterGroup" : "Small"]
            
            let request = SFRestRequest(method: .GET, path: "/services/data/v39.0/connect/communities/\(Constants.communityId)/chatter/mentions/completions", queryParams: query)
            
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                print(error?.localizedDescription as Any)
                reject(MyError.JSONError)
            }) { (result) in
                debugPrint(result)
                if let tmp = (result as AnyObject)["mentionCompletions"], let json = tmp as? [[String: Any]] {
                    let mentionCompletions = json.flatMap { MentionCompletion(json: $0) }
                    fullfill(mentionCompletions)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func getMentionValidations(parentId: String, mentionCompletions:[MentionCompletion], visibility: String = "AllUsers") -> Promise<[MentionCompletion]> {
        return Promise { fullfill, reject in
            var query: [String: String] = ["filterGroup" : "Small"]
            
            let first25 = mentionCompletions.prefix(25)
            let recordIds = first25.flatMap({$0.recordId}).joined(separator: ",")
            query = ["recordIds": recordIds, "visibility" : visibility, "parentId" : parentId]
            let request = SFRestRequest(method: .GET, path: "/services/data/v39.0/connect/communities/\(Constants.communityId)/chatter/mentions/validations", queryParams: query)
            
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                print(error?.localizedDescription as Any)
                reject(MyError.JSONError)
            }) { (result) in
                if let tmp = (result as AnyObject)["mentionValidations"], let json = tmp as? [[String: Any]] {
                    let validMentionCompletions = mentionCompletions.filter { mentionCompletion in
                        return json.contains { mentionValidation in
                            (mentionValidation as [String: Any])["validationStatus"] as! String == "Ok" && (mentionValidation as [String: Any])["recordId"] as! String == mentionCompletion.recordId
                        }
                    }
                    fullfill(validMentionCompletions)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    static let shared = APIClient()

}
