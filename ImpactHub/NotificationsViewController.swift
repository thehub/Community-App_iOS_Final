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
                    self.data.append(NotificationViewModel(pushNotification: item, cellSize: CGSize(width: cellWidth, height: 55)))
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
