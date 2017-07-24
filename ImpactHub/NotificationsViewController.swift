//
//  NotificationsViewController.swift
//  ImpactHub
//
//  Created by Niklas Alvaeus on 19/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit

class NotificationsViewController: UIViewController {

    var data = [CellRepresentable]()

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib.init(nibName: NotificationViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: NotificationViewModel.cellIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.imaGreyishBrown, NSFontAttributeName: UIFont(name:"GTWalsheim", size:18)!]
        self.navigationController?.navigationBar.barStyle = .default

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let doFadeIn = data.isEmpty
        firstly {
            APIClient.shared.getNotifications()
            }.then { items -> Void in
                self.data.removeAll()
                let cellWidth: CGFloat = self.view.frame.width
                items.forEach({ (item) in
                    self.data.append(NotificationViewModel(pushNotification: item, cellSize: CGSize(width: cellWidth, height: 60)))
                })
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if doFadeIn {
                    self.collectionView?.alpha = 0
                    self.collectionView?.reloadData()
                    self.collectionView?.setContentOffset(CGPoint.init(x: 0, y: -20), animated: false)
                    UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                        self.collectionView?.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
                        self.collectionView?.alpha = 1
                    }, completion: { (_) in
                        
                    })
                }
                else {
                    self.collectionView?.reloadData()
                }
            }.catch { error in
                debugPrint(error.localizedDescription)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var selectedId: String?
    var showPushNotification: PushNotification?
    var selectedGroup: Group?
    var selectedProject: Project?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        if segue.identifier == "ShowMember" {
            if let vc = segue.destination as? MemberViewController, let selectedId = selectedId {
                vc.userId = selectedId // FIXME ?
            }
        }
        else if segue.identifier == "ShowGroup" {
            if let vc = segue.destination as? GroupViewController, let showPushNotification = showPushNotification, let selectedGroup = self.selectedGroup {
                vc.group = selectedGroup
                vc.showPushNotification = showPushNotification
            }
        }
        else if segue.identifier == "ShowProject" {
            if let vc = segue.destination as? ProjectViewController, let showPushNotification = showPushNotification, let selectedProject = self.selectedProject {
                vc.project = selectedProject
                vc.showPushNotification = showPushNotification
            }
        }

    }
    
    var inTransit = false
}

extension NotificationsViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if inTransit {
            return
        }
        if let vm = data[indexPath.item] as? NotificationViewModel {
            
            switch vm.pushNotification.kind {
            case .comment(let id, let feedElementId, let chatterGroupId):
                self.showPushNotification = vm.pushNotification
                // Check if we're pushing to Group or to Project
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                self.inTransit = true
                firstly {
                    APIClient.shared.getGroupOrProject(chatterGroupId: chatterGroupId)
                    }.then { item -> Void in
                        if let group = item.group {
                            self.selectedGroup = group
                            self.performSegue(withIdentifier: "ShowGroup", sender: self)
                        }
                        else if let project = item.project {
                            self.selectedProject = project
                            self.performSegue(withIdentifier: "ShowProject", sender: self)
                        }
                    }.always {
                        self.inTransit = false
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }.catch { error in
                        debugPrint(error.localizedDescription)
                }
                break
            case .contactRequestApproved(let contactId):
                self.selectedId = contactId
                performSegue(withIdentifier: "ShowMember", sender: self)
            case .contactRequestIncomming(let contactId):
                self.selectedId = contactId
                performSegue(withIdentifier: "ShowMember", sender: self)
            case .likePost(let postId, let chatterGroupId), .likePost(let postId, let chatterGroupId):
                self.showPushNotification = vm.pushNotification
                // Check if we're pushing to Group or to Project
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                self.inTransit = true
                firstly {
                    APIClient.shared.getGroupOrProject(chatterGroupId: chatterGroupId)
                    }.then { item -> Void in
                        if let group = item.group {
                            self.selectedGroup = group
                            self.performSegue(withIdentifier: "ShowGroup", sender: self)
                        }
                        else if let project = item.project {
                            self.selectedProject = project
                            self.performSegue(withIdentifier: "ShowProject", sender: self)
                        }
                    }.always {
                        self.inTransit = false
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }.catch { error in
                        debugPrint(error.localizedDescription)
                }
                break
            default:
                break
            }
            
        }
    }
}

extension NotificationsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return data[indexPath.item].cellInstance(collectionView, indexPath: indexPath)
    }
}

extension NotificationsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return data[indexPath.item].cellSize
        
    }
}
