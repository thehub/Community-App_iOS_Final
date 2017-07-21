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
            if let pushNotification = note.userInfo?["pushNotification"] as? PushNotification.Kind {
                self.handlePushNotification(pushNotification)
            }
        }

        if let pushNotification = AppDelegate.pushNotification {
            self.handlePushNotification(pushNotification)
        }
    }

    
    
    func handlePushNotification(_ pushNotification: PushNotification.Kind) {
        AppDelegate.pushNotification = nil
        switch pushNotification {
            
        case .comment(let id, let feedElementId, let chatterGroupId):
//            self.selectedIndex = 0
//            let nvc = self.viewControllers?[self.selectedIndex] as! UINavigationController
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "GroupNewsItem") as! GroupNewsItemViewController
//            vc.postId = feedElementId
//            nvc.pushViewController(vc, animated: true)
//            AppDelegate.pushNotification = nil
            break
            
        case .postMention(let postId, let chatterGroupId):
            debugPrint(postId)
//            self.selectedIndex = 0
//            let nvc = self.viewControllers?[self.selectedIndex] as! UINavigationController
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "GroupNewsItem") as! GroupNewsItemViewController
//            vc.postId = postId
//            nvc.pushViewController(vc, animated: true)
//            AppDelegate.pushNotification = nil
            break
        case .commentMention(let commentId, let chatterGroupId):
            break
        case .likePost(let postId, let chatterGroupId):
            debugPrint(postId)
            break
        case .likeComment(let commentId, let chatterGroupId):
            break
        case .privateMessage(let postId):
            debugPrint(postId)
        case .contactRequestApproved(let userId):
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            firstly {
                ContactRequestManager.shared.refresh()
                }.then { contactRequests -> Void in
//                    self.selectedIndex = 0
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
                    // Incomming
//                    let incomming = ContactRequestManager.shared.getIncommingContactRequests()
//                    incomming.forEach({ (contactRequest) in
//                        if let member = members.filter ({$0.id == contactRequest.contactFromId }).first {
//                            member.contactRequest = contactRequest
//                            let viewModel = ContactIncommingViewModel(member: member, contactCellDelegate: self, cellSize: CGSize(width: cellWidth, height: 215))
//                            self.dataIncomming.append(viewModel)
//                        }
//                    })
                }.then {
                    APIClient.shared.getMember(userId: userId)
                }.then { member -> Void in
                    let contactRequest = ContactRequestManager.shared.getRelevantContactRequestFor(member: member)
                    member.contactRequest = contactRequest
  //                  self.selectedIndex = 0
                    let nvc = self.viewControllers?[self.selectedIndex] as! UINavigationController
                    let storyboard = UIStoryboard(name: "Messages", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "ContactIncommingViewController") as! ContactIncommingViewController
                    vc.member = member
                    nvc.pushViewController(vc, animated: true)
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
