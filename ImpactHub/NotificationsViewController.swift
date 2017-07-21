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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        if segue.identifier == "ShowMember" {
            if let vc = segue.destination as? MemberViewController, let selectedId = selectedId {
                vc.userId = selectedId // FIXME ?
            }
        }
    }
}

extension NotificationsViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? NotificationViewModel {
            
            switch vm.pushNotification.kind {
            case .comment(let id, let feedElementId, let chatterGroupId):
                break
            case .contactRequestApproved(let contactId):
                self.selectedId = contactId
                performSegue(withIdentifier: "ShowMember", sender: self)
            case .contactRequestIncomming(let contactId):
                self.selectedId = contactId
                performSegue(withIdentifier: "ShowMember", sender: self)
            case .likeComment(let commentId):
                print("liked comment")
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
