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
        case .comment( _, let feedElementId):
//            self.selectedIndex = 0
//            let nvc = self.viewControllers?[0] as! UINavigationController
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "GroupNewsItem") as! GroupNewsItemViewController
//            vc.postId = feedElementId
//            nvc.pushViewController(vc, animated: true)
//            AppDelegate.pushNotification = nil
            break
        case .postMention(let postId), .commentMention(let postId):
            debugPrint(postId)
//            self.selectedIndex = 0
//            let nvc = self.viewControllers?[0] as! UINavigationController
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "GroupNewsItem") as! GroupNewsItemViewController
//            vc.postId = postId
//            nvc.pushViewController(vc, animated: true)
//            AppDelegate.pushNotification = nil
            break
        case .likePost(let postId), .likeComment(let postId):
            debugPrint(postId)
        case .privateMessage(let postId):
            debugPrint(postId)
        case .contactRequestIncomming(let contactId), .contactRequestApproved(let contactId):
            firstly {
                ContactRequestManager.shared.refresh()
                }.then { contactRequests -> Void in
                    self.selectedIndex = 0
                    let nvc = self.viewControllers?[0] as! UINavigationController
                    let storyboard = UIStoryboard(name: "Home", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "MemberViewController") as! MemberViewController
                    vc.memberId = contactId
                    nvc.pushViewController(vc, animated: true)
                }.always {
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
