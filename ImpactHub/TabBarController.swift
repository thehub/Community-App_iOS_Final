//
//  TabBarController.swift
//  ImpactHub
//
//  Created by Niklas on 15/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit

class TabBarController: UITabBarController {

    var observer: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.imaGrapefruit, size: CGSize(width: 22, height: tabBar.frame.height), lineWidth: 3.0)
        
        self.observer = NotificationCenter.default.addObserver(forName: NSNotification.Name.openPush, object: nil, queue: OperationQueue.main) { note in
            if let pushNotification = note.userInfo?["pushNotification"] as? PushNotification {
                self.handlePushNotification(pushNotification)
            }
        }
        
        if let pushNotification = SessionManager.shared.pushNotification {
            self.handlePushNotification(pushNotification)
        }
    }

    var inTransit = false
    
    func handlePushNotification(_ pushNotification: PushNotification) {
        SessionManager.shared.pushNotification = nil
        if inTransit {
            return
        }
        switch pushNotification.kind {
            
        case .comment(let id, let feedElementId, let chatterGroupId):
            // Check if we're pushing to Group or to Project
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.inTransit = true
            firstly {
                APIClient.shared.getGroupOrProject(chatterGroupId: chatterGroupId)
                }.then { item -> Void in
                    if let group = item.group {
                        let nvc = self.viewControllers?[self.selectedIndex] as! UINavigationController
                        let storyboard = UIStoryboard(name: "Home", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "GroupViewController") as! GroupViewController
                        vc.group = group
                        vc.showPushNotification = pushNotification
                        nvc.pushViewController(vc, animated: true)
                    }
                    else if let project = item.project {
                        let nvc = self.viewControllers?[self.selectedIndex] as! UINavigationController
                        let storyboard = UIStoryboard(name: "Home", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "ProjectViewController") as! ProjectViewController
                        vc.project = project
                        vc.showPushNotification = pushNotification
                        nvc.pushViewController(vc, animated: true)
                    }
                }.always {
                    self.inTransit = false
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }.catch { error in
                    debugPrint(error.localizedDescription)
            }
            break
        case .postMention(let postId, let chatterGroupId):
            debugPrint(postId)
            break
        case .commentMention(let commentId, let chatterGroupId):
            break
        case .likePost(let postId, let chatterGroupId):
             // Check if we're pushing to Group or to Project
             UIApplication.shared.isNetworkActivityIndicatorVisible = true
             self.inTransit = true
             firstly {
                APIClient.shared.getGroupOrProject(chatterGroupId: chatterGroupId)
                }.then { item -> Void in
                    if let group = item.group {
                        let nvc = self.viewControllers?[self.selectedIndex] as! UINavigationController
                        let storyboard = UIStoryboard(name: "Home", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "GroupViewController") as! GroupViewController
                        vc.group = group
                        vc.showPushNotification = pushNotification
                        nvc.pushViewController(vc, animated: true)
                    }
                    else if let project = item.project {
                        let nvc = self.viewControllers?[self.selectedIndex] as! UINavigationController
                        let storyboard = UIStoryboard(name: "Home", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "ProjectViewController") as! ProjectViewController
                        vc.project = project
                        vc.showPushNotification = pushNotification
                        nvc.pushViewController(vc, animated: true)
                    }
                }.always {
                    self.inTransit = false
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }.catch { error in
                    debugPrint(error.localizedDescription)
             }
            break
        case .likeComment(let commentId, let chatterGroupId):
            // Check if we're pushing to Group or to Project
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.inTransit = true
            firstly {
                APIClient.shared.getGroupOrProject(chatterGroupId: chatterGroupId)
                }.then { item -> Void in
                    if let group = item.group {
                        let nvc = self.viewControllers?[self.selectedIndex] as! UINavigationController
                        let storyboard = UIStoryboard(name: "Home", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "GroupViewController") as! GroupViewController
                        vc.group = group
                        vc.showPushNotification = pushNotification
                        nvc.pushViewController(vc, animated: true)
                    }
                    else if let project = item.project {
                        let nvc = self.viewControllers?[self.selectedIndex] as! UINavigationController
                        let storyboard = UIStoryboard(name: "Home", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "ProjectViewController") as! ProjectViewController
                        vc.project = project
                        vc.showPushNotification = pushNotification
                        nvc.pushViewController(vc, animated: true)
                    }
                }.always {
                    self.inTransit = false
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }.catch { error in
                    debugPrint(error.localizedDescription)
            }
            break
        case .privateMessage(let conversationId):
            debugPrint(conversationId)
            self.selectedIndex = 3
            let nvc = self.viewControllers?[self.selectedIndex] as! UINavigationController
            let storyboard = UIStoryboard(name: "Messages", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MessagesThreadViewController") as! MessagesThreadViewController
            vc.conversationId = conversationId
            nvc.pushViewController(vc, animated: true)
            break
        case .contactRequestApproved(let userId):
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            firstly {
                ContactRequestManager.shared.refresh()
                }.then { contactRequests -> Void in
                    let nvc = self.viewControllers?[self.selectedIndex] as! UINavigationController
                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "MemberViewController") as! MemberViewController
                    vc.userId = userId // FIXME:
                    nvc.pushViewController(vc, animated: true)
                }.always {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }.catch { error in
                    debugPrint(error.localizedDescription)
            }
        case .contactRequestIncomming(let userId):
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            firstly {
                ContactRequestManager.shared.refresh()
                }.then { contactRequests -> Void in
                }.then {
                    APIClient.shared.getMember(userId: userId)
                }.then { member -> Void in
                    let contactRequest = ContactRequestManager.shared.getRelevantContactRequestFor(member: member)
                    member.contactRequest = contactRequest
                    // Make sure the state is still correct
                    if contactRequest?.status == .approveDecline {
                        let nvc = self.viewControllers?[self.selectedIndex] as! UINavigationController
                        let storyboard = UIStoryboard(name: "Messages", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "ContactIncommingViewController") as! ContactIncommingViewController
                        vc.member = member
                        nvc.pushViewController(vc, animated: true)
                    }
                }.always {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }.catch { error in
                    debugPrint(error.localizedDescription)
            }
        case .unknown:
            debugPrint("unkown push kind")
        }
    }
    
    
    deinit {
        if let observer = self.observer {
            NotificationCenter.default.removeObserver(observer, name: NSNotification.Name.onLogin, object: nil)
        }
    }
}
