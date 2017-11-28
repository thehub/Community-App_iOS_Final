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

    struct SelectFields {
        static let GROUP = "id, name, CountOfMembers__c, ImageURL__c, Group_Descr__c,Related_Impact_Goal__c, Impact_Hub_Cities__c, ChatterGroupId__c, Directory_Style__c,Sector__c,ChatterGroupType__c"
        static let PROJECT = "id,CreatedById, name,Related_Impact_Goal__c,ChatterGroupId__c ,Group_Descr__c, ImageURL__c, Directory_Style__c,Sector__c, Organisation__r.id, Organisation__r.Number_of_Employees__c, Organisation__r.Impact_Hub_Cities__c, Organisation__r.name,ChatterGroupType__c"
        // When we're asking for either a Project or a Group, merge both select values. Doing it code didn't work...
        static let GROUP_PROJECT = "id, name, CountOfMembers__c, ImageURL__c, Group_Descr__c, Impact_Hub_Cities__c, ChatterGroupId__c, Directory_Style__c,Sector__c, CreatedById, Related_Impact_Goal__c, Organisation__r.id, Organisation__r.Number_of_Employees__c, Organisation__r.Impact_Hub_Cities__c, Organisation__r.name,ChatterGroupType__c"
        static let GOAL = "Directory__c,Goal_Summary__c,Goal__c,Id,Name"
        static let CONTACT = "id, firstname,lastname,Account.Name, ProfilePic__c, Profession__c, Impact_Hub_Cities__c, User__c,Skills__c, AboutMe__c,Status_Update__c,Directory_Summary__c, Interested_SDG__c,How_Do_You_Most_Identify_with_Your_Curre__c,Twitter__c,Instagram__c,Facebook__c,Linked_In__c,(select Hub_Name__c from contact.Hubs__r)"
        static let COMPANY = "id, name, Number_of_Employees__c, Impact_Hub_Cities__c,Company_Summary__c, Sector_Industry__c, Logo_Image_Url__c, Banner_Image_Url__c,Affiliated_SDG__c, Twitter__c, Instagram__c, Facebook__c, LinkedIn__c, Website, Company_About_Us__c"
        // Job also has COMPANY fields by relation, to avoid extra api calls If updating COMPANY, make sure to also add these to Company__r. on JOB
        static let JOB = "id, name, Description__c, Salary2__c, Job_Type__c, Sector__c,Contact__c, Contact__r.AccountId,  Location__c, Applications_Close_Date__c,Related_Impact_Goal__c,Job_Image_URL__c,Company__c,Company__r.name,Company__r.Number_of_Employees__c, Company__r.Impact_Hub_Cities__c,Company__r.Company_Summary__c, Company__r.Sector_Industry__c, Company__r.Logo_Image_Url__c, Company__r.Banner_Image_Url__c, Company__r.Twitter__c, Company__r.Instagram__c, Company__r.Facebook__c, Company__r.LinkedIn__c, Company__r.Website, Company__r.Company_About_Us__c,Job_Application_URL__c"
        static let EVENT = "CreatedDate,Event_RegisterLink__c,Event_Description__c,Directory__c,Event_City__c,Event_Country__c,Event_Street__c,Event_ZipCode__c,Event_Classification__c,Event_Discount_Code__c,Event_Organiser_Type__c,Event_Quantity__c,Event_Sector__c,Event_Start_DateTime__c,Event_End_DateTime__c,Event_SubType__c,Event_Type__c,Event_Visibility__c,Id,LastModifiedDate,Name,Organiser__c,Organiser__r.name,OwnerId, Event_Image_URL__c"
    }

    // Hubs
    func getHubs() -> Promise<[Hub]> {
        
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQuery("select id, name FROM Account WHERE RecordTypeId IN (SELECT Id FROM RecordType WHERE SobjectType = 'Account' AND Name = 'Hub' AND IsActive = true)", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
//                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    let items = records.flatMap { Hub(json: $0) }
                    fullfill(items)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }

    
    // Goals
    func getGoals(offset: Int = 0) -> Promise<(goals: [Goal], offset: Int?)> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQuery("select id, name,  Active__c, ImageURL__c, Summary__c, Description__c from Taxonomy__c where Grouping__c ='SDG' OFFSET \(offset)", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
//                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    var offset: Int? = nil
                    let done = jsonResult["done"].bool ?? true
                    if done == false {
                        offset = records.count
                    }
                    let items = records.flatMap { Goal(json: $0) }
                    fullfill((goals: items, offset: offset))
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func getGroups(goalName: String) -> Promise<[Group]> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT \(SelectFields.GROUP) FROM Directory__c WHERE Directory_Style__c = 'Group'  AND isMakerSpecific__c = false AND Related_Impact_Goal__c LIKE '%\(goalName)%'", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
//                print(jsonResult)
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
    
    func getMyGroups() -> Promise<[String]> {
        return Promise { fullfill, reject in
            let query: [String: String] = ["filterGroup" : "Small"]
            let request = SFRestRequest(method: .GET, path: "/services/data/v39.0/connect/communities/\(Constants.communityId)/chatter/users/\(SessionManager.shared.me?.member.userId ?? "")/groups", queryParams: query)
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
                if let groups = jsonResult["groups"].array {
                    var items = [String]()
                    for group in groups {
                        if let item = group["id"].string {
                            items.append(item)
                        }
                    }
                    fullfill(items)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func joinGroup(groupId: String) -> Promise<String> {
        return Promise { fullfill, reject in
            var query: JSON!
            query = ["userId": SessionManager.shared.me?.member.userId ?? ""]
            let body = SFJsonUtils.jsonDataRepresentation(query.dictionaryObject)
            let request = SFRestRequest(method: .POST, path: "/services/data/v39.0/connect/communities/\(Constants.communityId)/chatter/groups/\(groupId)/members", queryParams: nil)
            request.setCustomRequestBodyData(body!, contentType: "application/json")
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                fullfill("ok")
            }
        }
    }

//    func leaveGroup(group: Group, completion: @escaping (Result<Group>) -> Void) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//
//        // Get membershipId first for the group
//        self.getMembers(groupID: group.id) { (result) in
//            switch result {
//            case .Success(let items):
//                if let meChatterActor = items.first(where: {$0.id == Model.shared.me?.id}) {
//                    var membershipId = meChatterActor.membershipID!
//                    let request = SFRestRequest(method: .DELETE, path: "/services/data/v39.0/connect/communities/\(Constants.communityId)/chatter/group-memberships/\(membershipId)", queryParams: nil)
//                    SFRestAPI.sharedInstance().send(request, fail: { (error) in
//                        print(error?.localizedDescription as Any)
//                        DispatchQueue.main.async{
//                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                            completion(Result.Failure(MyError.Error((error?.localizedDescription)!)))
//                        }
//                    }) { (result) in
//                        if let index = self.myGroups.index(where: {$0.id == group.id}) {
//                            self.myGroups.remove(at: index)
//                        }
//                        self.groups.append(group)
//                        DispatchQueue.main.async{
//                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                            completion(Result.Success(group))
//                        }
//                    }
//                }
//                else {
//                    DispatchQueue.main.async{
//                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                        completion(Result.Failure(MyError.JSONError))
//                    }
//                }
//                break
//            case .Failure(let error):
//                DispatchQueue.main.async{
//                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                    completion(Result.Failure(MyError.Error((error.localizedDescription))))
//                }
//                break
//            }
//        }
//    }
        
        
    func getMembers(goalName: String) -> Promise<[Member]> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT \(SelectFields.CONTACT) FROM Contact WHERE Interested_SDG__c INCLUDES ('\(goalName)')", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
//                debugPrint(jsonResult)
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

    
    // Projects
    func getProjects(offset: Int = 0) -> Promise<(projects: [Project], offset: Int?)> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT \(SelectFields.PROJECT) FROM Directory__c WHERE Directory_Style__c = 'Project' AND isMakerSpecific__c = false OFFSET \(offset)", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
//                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    var offset: Int? = nil
                    let done = jsonResult["done"].bool ?? true
                    if done == false {
                        offset = records.count
                    }
                    let items = records.flatMap { Project(json: $0) }
                    fullfill((projects: items, offset: offset))
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func getObjectives(projectId: String) -> Promise<[Project.Objective]> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT Directory__c,Goal_Summary__c,Goal__c,Id,Name FROM Directory_Goal__c WHERE Directory__c='\(projectId)'", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
//                debugPrint(jsonResult)
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
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT \(SelectFields.CONTACT) FROM Contact WHERE id IN (SELECT contactID__c FROM Directory_Member__c WHERE DirectoryID__c='\(projectId)')", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
//                debugPrint(jsonResult)
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
    
    func getJobs(projectId: String) -> Promise<[Job]> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT \(SelectFields.JOB) FROM Job__c WHERE Project__r.id='\(projectId)'", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
//                debugPrint(jsonResult)
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
    

    // Filters
//    func getFilters(grouping: Filter.Grouping) -> Promise<[Filter]> {
//        return Promise { fullfill, reject in
//            SFRestAPI.sharedInstance().performSOQLQuery("SELECT name, Grouping__c FROM taxonomy__c where active__c = true AND Grouping__c ='\(grouping.rawValue)'", fail: { (error) in
//                print("error \(error?.localizedDescription as Any)")
//                reject(error ?? MyError.JSONError)
//            }) { (result) in
//                let jsonResult = JSON(result!)
//                print(jsonResult)
//                if let records = jsonResult["records"].array {
//                    let items = records.flatMap { Filter(json: $0) }
//                    print(items.count)
//                    print(items)
//                    fullfill(items)
//                }
//                else {
//                    reject(MyError.JSONError)
//                }
//            }
//        }
//    }
    

    // Companies
    func getCompanies(offset: Int = 0) -> Promise<(companies: [Company], offset: Int?)> {
        return Promise { fullfill, reject in
            
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT \(SelectFields.COMPANY) FROM account where id IN (SELECT accountid FROM contact WHERE user__c != null) OFFSET \(offset)", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    var offset: Int? = nil
                    let done = jsonResult["done"].bool ?? true
                    if done == false {
                        offset = records.count
                    }
                    let items = records.flatMap { Company(json: $0) }
                    fullfill((companies: items, offset: offset))
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func getCompany(companyId:String) -> Promise<Company> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT \(SelectFields.COMPANY) FROM account WHERE id = '\(companyId)'", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
//                debugPrint(jsonResult)
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
    
    func getProjects(companyId: String) -> Promise<[Project]> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT \(SelectFields.PROJECT) FROM Directory__c WHERE Directory_Style__c ='Project' AND Organisation__c ='\(companyId)' AND isMakerSpecific__c = false", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
//                debugPrint(jsonResult)
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
    
    func getMembers(companyId: String) -> Promise<[Member]> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT \(SelectFields.CONTACT) FROM Contact WHERE User__c != NULL AND accountid='\(companyId)'", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
//                debugPrint(jsonResult)
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
    
    func getCompanyServices(companyId: String) -> Promise<[Company.Service]> {
        return Promise { fullfill, reject in
            
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT id, name, Service_Description__c FROM Company_Service__c WHERE Company__r.id ='\(companyId)'", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
//                debugPrint(jsonResult)
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


    
    // Members
    func getMembers(offset: Int = 0) -> Promise<(members: [Member], offset: Int?)> {
        // TODO: Add pagination
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT \(SelectFields.CONTACT) FROM Contact WHERE User__c != null AND User__r.isactive = true AND Portal_Profile_Complete__c = true OFFSET \(offset)", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
//                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
//                    print("Records count: \(records.count)")
                    var offset: Int? = nil
                    let done = jsonResult["done"].bool ?? true
                    if done == false {
                        offset = records.count
                    }
                    let items = records.flatMap { Member(json: $0) }
                    fullfill((members: items, offset: offset))
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func getMembers(searchTerm: String, offset: Int = 0) -> Promise<(members: [Member], offset: Int?)> {
        return Promise { fullfill, reject in
            let query: [String: String] = ["searchTerm" : searchTerm, "offset" : String(offset)]
            let body = SFJsonUtils.jsonDataRepresentation(query)
            let request = SFRestRequest(method: .POST, path: "/services/apexrest/callMemberSearch", queryParams: nil)
            request.endpoint = "/services/apexrest/callMemberSearch"
            request.path = "/services/apexrest/callMemberSearch"
            request.setCustomRequestBodyData(body!, contentType: "application/json")
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                print(error?.localizedDescription as Any)
                reject(MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON.init(result!)
//                debugPrint(jsonResult) // id
                if let records = jsonResult["records"].array {
//                    print("Records count: \(records.count)")
                    var offset: Int? = nil
                    let done = jsonResult["done"].bool ?? true
                    if done == false {
                        offset = records.count
                    }
                    let items = records.flatMap { Member(json: $0) }
                    fullfill((members: items, offset: offset))
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func getGroups(offset: Int = 0) -> Promise<(groups: [Group], offset: Int?)> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT \(SelectFields.GROUP) FROM Directory__c WHERE Directory_Style__c =  'Group' AND isMakerSpecific__c = false", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
                if let records = jsonResult["records"].array {
                    var offset: Int? = nil
                    let done = jsonResult["done"].bool ?? true
                    if done == false {
                        offset = records.count
                    }
                    let items = records.flatMap { Group(json: $0) }
                    fullfill((groups: items, offset: offset))
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func getGroups(contactId: String) -> Promise<[Group]> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT \(SelectFields.GROUP) FROM Directory__c WHERE Directory_Style__c = 'Group'  AND isMakerSpecific__c = false AND id IN (SELECT DirectoryID__c FROM Directory_Member__c WHERE ContactID__c ='\(contactId)')", fail: { (error) in
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
    
    func getGroupsYouManage(contactId: String) -> Promise<[Group]> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT \(SelectFields.GROUP) FROM Directory__c WHERE Directory_Style__c = 'Group' AND id IN (SELECT DirectoryID__c FROM Directory_Member__c WHERE Member_Role__c = 'Manager' AND ContactID__c ='\(contactId)')", fail: { (error) in
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
    
    // When a push comes if for a comment, we don't know if it's on a project or a group, so incude this in the query, then return a tuple ith only one of them set
    func getGroupOrProject(chatterGroupId: String) -> Promise<(group: Group?, project: Project?)> {
        return Promise { fullfill, reject in
            // Since we're asking for either a Project or a Group, merge both select values
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT \(SelectFields.GROUP_PROJECT) FROM Directory__c WHERE ChatterGroupId__c ='\(chatterGroupId)' AND isMakerSpecific__c = false", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
//                print(jsonResult)
                if let record = jsonResult["records"].array?.first {
                    if record["Directory_Style__c"].string == "Group" {
                        if let group = Group(json: record) {
                            fullfill((group:group, project: nil))
                        }
                        else {
                            reject(MyError.Error("No group found"))
                        }
                    }
                    else if record["Directory_Style__c"].string == "Project" {
                        if let project = Project(json: record) {
                            fullfill((group:nil, project: project))
                        }
                        else {
                            reject(MyError.Error("No project found"))
                        }
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
    
    func getProjects(contactId: String) -> Promise<[Project]> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQuery("select \(SelectFields.PROJECT) FROM Directory__c WHERE Directory_Style__c ='Project' AND isMakerSpecific__c = false AND id IN (select DirectoryID__c FROM Directory_Member__c WHERE ContactID__c ='\(contactId)')", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
//                debugPrint(jsonResult)
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
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT id,name,Skill_Description__c FROM Contact_Skills__c WHERE Contact__r.id ='\(contactId)'", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
//                debugPrint(jsonResult)
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

    func getMembers(contactIds:[String]) -> Promise<[Member]> {
        return Promise { fullfill, reject in
            let contactIdsString = contactIds.map({"'\($0)'"}).joined(separator: ",")
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT \(SelectFields.CONTACT) FROM Contact where id IN (\(contactIdsString))", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
//                debugPrint(jsonResult)
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
    
    func getMember(contactId:String) -> Promise<Member> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT \(SelectFields.CONTACT) FROM Contact WHERE id = '\(contactId)'", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
//                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    let items = records.flatMap { Member(json: $0) }
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
    
    func getMember(userId:String) -> Promise<Member> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT \(SelectFields.CONTACT) FROM Contact WHERE User__c = '\(userId)'", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
//                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    let items = records.flatMap { Member(json: $0) }
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
    
    
    func getMe(userId:String) -> Promise<Me> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT \(SelectFields.CONTACT) FROM Contact WHERE User__c = '\(userId)'", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
//                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    let items = records.flatMap { Member(json: $0) }
                    if let item = items.first {
                        fullfill(Me(member: item))
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

    // Events
    func getEvents(offset: Int = 0) -> Promise<(events: [Event], offset: Int?)> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT \(SelectFields.EVENT) FROM Event__c WHERE Event_End_DateTime__c >= \(Date().eventDate()) ORDER BY Event_Start_DateTime__c ASC", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.Error("Error"))
            }) { (result) in
                let jsonResult = JSON(result!)
                //                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    var offset: Int? = nil
                    let done = jsonResult["done"].bool ?? true
                    if done == false {
                        offset = records.count
                    }
                    let items = records.flatMap { Event(json: $0) }
                    fullfill((events: items, offset: offset))
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }

    func getEventsYouManage(contactId: String) -> Promise<[Event]> {
        return Promise { fullfill, reject in
            // TODO: Send in pagination?
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT \(SelectFields.EVENT) FROM Event__c WHERE Organiser__c = '\(contactId)'", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.Error("Error"))
            }) { (result) in
                let jsonResult = JSON(result!)
                //                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    let items = records.flatMap { Event(json: $0) }
                    fullfill(items)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func getEventsAttending(contactId: String) -> Promise<[Event]> {
        return Promise { fullfill, reject in
            // TODO: Send in pagination?
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT \(SelectFields.EVENT) FROM Event__c WHERE id in (SELECT Event__c FROM Event_Attendance__c WHERE Registered__c = true AND Contact__c = '\(contactId)') AND Event_End_DateTime__c >= \(Date().eventDate()) ORDER BY Event_Start_DateTime__c ASC", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.Error("Error"))
            }) { (result) in
                let jsonResult = JSON(result!)
//                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    let items = records.flatMap { Event(json: $0) }
                    fullfill(items)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    func attendEvent(contactId:String, eventId:String) -> Promise<String> {
        return Promise { fullfill, reject in
            let query: [String: String] = ["contactId" : contactId, "eventId" : eventId]
            let body = SFJsonUtils.jsonDataRepresentation(query)
            let request = SFRestRequest(method: .POST, path: "/services/apexrest/attendEvent", queryParams: nil)
            request.endpoint = "/services/apexrest/attendEvent"
            request.path = "/services/apexrest/attendEvent"
            request.setCustomRequestBodyData(body!, contentType: "application/json")
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                print(error?.localizedDescription as Any)
                reject(MyError.JSONError)
            }) { (result) in
                print(String(data: result as! Data, encoding: .utf8) ?? "")
                if let resultData = result as? Data, let resultIdString = String(data: resultData, encoding: .utf8) {
                    fullfill(resultIdString)
                }
                else {
                    fullfill("")
                }
            }
        }
    }
    
    func unattendEvent(contactId:String, eventId:String) -> Promise<String> {
        return Promise { fullfill, reject in
            let query: [String: String] = ["contactId" : contactId, "eventId" : eventId]
            let body = SFJsonUtils.jsonDataRepresentation(query)
            let request = SFRestRequest(method: .POST, path: "/services/apexrest/unAttendEvent", queryParams: nil)
            request.endpoint = "/services/apexrest/unAttendEvent"
            request.path = "/services/apexrest/unAttendEvent"
            request.setCustomRequestBodyData(body!, contentType: "application/json")
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                print(error?.localizedDescription as Any)
                reject(MyError.JSONError)
            }) { (result) in
                print(String(data: result as! Data, encoding: .utf8) ?? "")
                if let resultData = result as? Data, let resultIdString = String(data: resultData, encoding: .utf8) {
                    fullfill(resultIdString)
                }
                else {
                    fullfill("")
                }
            }
        }
    }

    
    // Jobs
    func getJobs(offset: Int = 0) -> Promise<(jobs: [Job], offset: Int?)> {
        return Promise { fullfill, reject in
            // TODO: Send in pagination?
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT \(SelectFields.JOB) FROM Job__c WHERE Applications_Close_Date__c >= \(Date().shortDate()) OFFSET \(offset)", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.Error("Error"))
            }) { (result) in
                let jsonResult = JSON(result!)
//                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    var offset: Int? = nil
                    let done = jsonResult["done"].bool ?? true
                    if done == false {
                        offset = records.count
                    }
                    let items = records.flatMap { Job(json: $0) }
                    fullfill((jobs: items, offset: offset))
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    // to get related project to job
    func getProject(jobId: String) -> Promise<[Project]> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT \(SelectFields.PROJECT) FROM Directory__c WHERE isMakerSpecific__c = false AND Organisation__c in (SELECT Company__c FROM Job__c WHERE id ='\(jobId)')", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.Error("Error"))
            }) { (result) in
                let jsonResult = JSON(result!)
//                debugPrint(jsonResult)
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
    
    // to get related jobs to job
    func getJobs(jobId: String, location__c: String, company__c: String, accountId: String) -> Promise<[Job]> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT \(SelectFields.JOB) FROM Job__c WHERE id='\(jobId)' AND (Location__c = '\(jobId)' OR Contact__r.AccountId = '\(jobId)' OR (Company__c  != null and  Company__c = '\(company__c)'))", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
                //                debugPrint(jsonResult)
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
    
    
    // Direct Message Request
    func createDMRequest(fromContactId:String, toContactId:String, message: String) -> Promise<String> {
        return Promise { fullfill, reject in
            let query: [String: String] = ["fromContactId" : fromContactId, "toContactId" : toContactId, "introMessage" : message]
            let body = SFJsonUtils.jsonDataRepresentation(query)
            let request = SFRestRequest(method: .POST, path: "/services/apexrest/CreateDMRequest", queryParams: nil)
            request.endpoint = "/services/apexrest/CreateDMRequest"
            request.path = "/services/apexrest/CreateDMRequest"
            request.setCustomRequestBodyData(body!, contentType: "application/json")
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                print(error?.localizedDescription as Any)
                reject(MyError.JSONError)
            }) { (result) in
                print(String(data: result as! Data, encoding: .utf8) ?? "")
                if let resultData = result as? Data, let resultIdString = String(data: resultData, encoding: .utf8) {
                    fullfill(resultIdString)
                }
                else {
                    fullfill("")
                }
            }
        }
    }
    
    func updateDMRequest(id:String, status:DMRequest.Satus, pushUserId: String) -> Promise<String> {
        return Promise { fullfill, reject in
            let query: [String: String] = ["DM_id" : id, "Req_status" : status.rawValue, "pushUserId" : pushUserId]
            debugPrint(query)
            let body = SFJsonUtils.jsonDataRepresentation(query)
            let request = SFRestRequest(method: .POST, path: "/services/apexrest/UpdateDMRequest", queryParams: nil)
            request.endpoint = "/services/apexrest/UpdateDMRequest"
            request.path = "/services/apexrest/UpdateDMRequest"
            request.setCustomRequestBodyData(body!, contentType: "application/json")
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                print(error?.localizedDescription as Any)
                reject(MyError.JSONError)
            }) { (result) in
                print(String(data: result as! Data, encoding: .utf8) ?? "")
                fullfill("ok")
//                if let resultData = result as? Data, let resultString = String(data: resultData, encoding: .utf8), resultString == "Success" {
//                    fullfill("ok")
//                }
//                else {
//                    reject(MyError.JSONError)
//                }
            }
        }
    }
    
    func deleteDMRequest(id:String) -> Promise<String> {
        return Promise { fullfill, reject in
            let query: [String: String] = ["DM_id" : id]
            debugPrint(query)
            let body = SFJsonUtils.jsonDataRepresentation(query)
            let request = SFRestRequest(method: .POST, path: "/services/apexrest/DeleteDMRequest", queryParams: nil)
            request.endpoint = "/services/apexrest/DeleteDMRequest"
            request.path = "/services/apexrest/DeleteDMRequest"
            request.setCustomRequestBodyData(body!, contentType: "application/json")
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                print(error?.localizedDescription as Any)
                reject(MyError.JSONError)
            }) { (result) in
                print(String(data: result as! Data, encoding: .utf8) ?? "")
                fullfill("ok")
//                if let resultData = result as? Data, let resultString = String(data: resultData, encoding: .utf8) {
//                    print(resultString)
//                    if resultString.contains("Success") {
//                        fullfill("ok")
//                    }
//                    else {
//                        reject(MyError.JSONError)
//                    }
//                }
//                else {
//                    reject(MyError.JSONError)
//                }
            }
        }
    }
    
    func getDMRequests() -> Promise<[DMRequest]> {
        return Promise { fullfill, reject in
            guard let contactId = SessionManager.shared.me?.member.contactId else {
                reject(MyError.Error("No contactId for me"))
                return
            }
            
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT ContactFrom__c,ContactTo__c,ContactToUserId__c,ContactFromUserId__c,CreatedDate,Id,Name,Status__c,Introduction_Message__c FROM DM_Request__c WHERE ContactFrom__c = '\(contactId)' OR contactTo__c = '\(contactId)'", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
//                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    let items = records.flatMap { DMRequest(json: $0) }
                    fullfill(items)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    
    
    // Notifications
    func getNotifications() -> Promise<[PushNotification]> {
        return Promise { fullfill, reject in
            SFRestAPI.sharedInstance().performSOQLQuery("SELECT CreatedDate,FromUserId__c,Id,isRead__c,Name,RelatedId__c,Sent__c,Type__c,ProfilePicURL__c,Message__c, ChatterGroupId__c FROM PushNotification__c WHERE toUserId__c = '\(SessionManager.shared.me?.member.userId ?? "")' AND FromUserId__c != '\(SessionManager.shared.me?.member.userId ?? "")' ORDER BY CreatedDate DESC LIMIT 250", fail: { (error) in
                print("error \(error?.localizedDescription as Any)")
                reject(error ?? MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
//                debugPrint(jsonResult)
                if let records = jsonResult["records"].array {
                    let items = records.flatMap { PushNotification(json: $0) }
                    fullfill(items)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    
    func sendPush(fromUserId: String, toUserIds: String, pushType: PushNotification.Kind, relatedId: String) -> Promise<String> {
        return Promise { fullfill, reject in
            let query: [String: String] = ["fromUserId" : fromUserId, "toUserIds" : toUserIds, "pushType" : pushType.getParameter(), "relatedId" : relatedId]
//            debugPrint(query)
            let body = SFJsonUtils.jsonDataRepresentation(query)
            let request = SFRestRequest(method: .POST, path: "/services/apexrest/pushNotificationFromSF", queryParams: nil)
            request.endpoint = "/services/apexrest/pushNotificationFromSF"
            request.path = "/services/apexrest/pushNotificationFromSF"
            request.setCustomRequestBodyData(body!, contentType: "application/json")
//            request.setHeaderValue("\(u_long(body?.count ?? 0))", forHeaderName: "Content-Length")
            
//            print(request)
            
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                print(error?.localizedDescription as Any)
                reject(MyError.JSONError)
            }) { (result) in
//                let jsonResult = JSON.init(result!)
                // For now sales force won't give an error or sucess, so just silently accept it
                fullfill("ok")
                //                let jsonResult = JSON.init(result!)
                //                print(jsonResult)
                //                if jsonResult.string == "Success" {
                //                    fullfill("ok")
                //                }
                //                else {
                //                    reject(MyError.JSONError)
                //                }
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
//                debugPrint(jsonResult)
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
//                print(jsonResult)
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
            if let fileId = fileId {
                query = ["body" : ["messageSegments" : messageSegments], "feedElementType": "FeedItem", "subjectId": groupID, "capabilities": ["files": ["items": ["id": fileId]]]]
            }
            else {
                query = ["body" : ["messageSegments" : messageSegments], "feedElementType": "FeedItem", "subjectId": groupID]
            }
            
            let body = SFJsonUtils.jsonDataRepresentation(query.dictionaryObject)
            let request = SFRestRequest(method: .POST, path: "/services/data/v39.0/connect/communities/\(Constants.communityId)/chatter/feed-elements", queryParams: nil)
            request.setCustomRequestBodyData(body!, contentType: "application/json")
            
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
//            request.setHeaderValue("\(u_long(query.characters.count))", forHeaderName: "Content-Length")
            
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
    
    
    // Like on comments give Salesforce error 1, so removed that from the comments view at the moment.
    func likeFeedItem(feedId: String) -> Promise<String> {
        return Promise { fullfill, reject in

            let request = SFRestRequest(method: .POST, path: "/services/data/v40.0/connect/communities/\(Constants.communityId)/chatter/feed-elements/\(feedId)/capabilities/chatter-likes/items?include=/id", queryParams: nil)
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
    
    func unlikeFeedItem(myLikeId: String) -> Promise<String> {
        return Promise { fullfill, reject in
            let request = SFRestRequest(method: .DELETE, path: "/services/data/v40.0/connect/communities/\(Constants.communityId)/chatter/likes/\(myLikeId)", queryParams: nil)
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                print(error?.localizedDescription as Any)
                reject(MyError.JSONError)
            }) { (result) in
//                debugPrint(result)
                fullfill("ok")
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
//                debugPrint(result)
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
    
    
    func sendMessage(message: String, userIds: [String]?, inReplyTo: String?) -> Promise<Message> {
        return Promise { fullfill, reject in
            var query: JSON!
            if let inReplyTo = inReplyTo {
                query = ["body": message, "inReplyTo" : inReplyTo]
            }
            else if let userIds = userIds {
                let recipients = userIds // members.flatMap({$0.userId}) //.joined(separator: ",")
                query = ["body": message, "recipients" : recipients]
            }
            else {
                reject(MyError.Error("Error"))
                return
            }
            let body = SFJsonUtils.jsonDataRepresentation(query.dictionaryObject)
            let request = SFRestRequest(method: .POST, path: "/services/data/v39.0/connect/communities/\(Constants.communityId)/chatter/users/me/messages/", queryParams: nil)
            request.setCustomRequestBodyData(body!, contentType: "application/json")
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                print(error?.localizedDescription as Any)
                reject(error ?? MyError.Error("Error"))
            }) { (result) in
//                print(result)
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
//                debugPrint(result as Any)
                if let read = (result as AnyObject)["read"] as? Bool {
                    fullfill(read)
                }
                else {
                    reject(MyError.JSONError)
                }
            }
        }
    }
    
    
    // Report abuse
    func reportAbuse(fromUserId:String, message: String) -> Promise<String> {
        return Promise { fullfill, reject in
            let query: [String: String] = ["fromUserId" : fromUserId, "message" : message]
            let body = SFJsonUtils.jsonDataRepresentation(query)
            let request = SFRestRequest(method: .POST, path: "/services/apexrest/callReportAbuse", queryParams: nil)
            request.endpoint = "/services/apexrest/callReportAbuse"
            request.path = "/services/apexrest/callReportAbuse"
            request.setCustomRequestBodyData(body!, contentType: "application/json")
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                print(error?.localizedDescription as Any)
                reject(MyError.JSONError)
            }) { (result) in
                print(String(data: result as! Data, encoding: .utf8) ?? "")
                if let resultData = result as? Data, let resultIdString = String(data: resultData, encoding: .utf8) {
                    fullfill(resultIdString)
                }
                else {
                    fullfill("")
                }
            }
        }
    }
    
    func globalSearch(searchTerm:String) -> Promise<(members: [Member], groups: [Group], projects: [Project], companies: [Company], events: [Event])> {
        return Promise { fullfill, reject in
            let query: [String: String] = ["searchTerm" : searchTerm]
            let body = SFJsonUtils.jsonDataRepresentation(query)
            let request = SFRestRequest(method: .POST, path: "services/apexrest/callGlobalSearch", queryParams: nil)
            request.endpoint = "services/apexrest/callGlobalSearch"
            request.path = "services/apexrest/callGlobalSearch"
            request.setCustomRequestBodyData(body!, contentType: "application/json")
            SFRestAPI.sharedInstance().send(request, fail: { (error) in
                print(error?.localizedDescription as Any)
                reject(MyError.JSONError)
            }) { (result) in
                let jsonResult = JSON(result!)
                
                var members = [Member]()
                var groups = [Group]()
                var projects = [Project]()
                var companies = [Company]()
                var events = [Event]()

                if let records = jsonResult["Members"].array {
                    let items = records.flatMap { Member(json: $0) }
                    members = items
                }
                if let records = jsonResult["Groups"].array {
                    let items = records.flatMap { Group(json: $0) }
                    groups = items
                }
                if let records = jsonResult["Projects"].array {
                    let items = records.flatMap { Project(json: $0) }
                    projects = items
                }
                if let records = jsonResult["Companies"].array {
                    let items = records.flatMap { Company(json: $0) }
                    companies = items
                }
                if let records = jsonResult["Events"].array {
                    let items = records.flatMap { Event(json: $0) }
                    events = items
                }

                fullfill( (members: members, groups: groups, projects: projects, companies: companies, events: events) )
            }
        }
    }
    
    static let shared = APIClient()

}
