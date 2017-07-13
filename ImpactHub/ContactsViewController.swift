//
//  ContactsViewController.swift
//  ImpactHub
//
//  Created by Niklas on 13/07/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit

class ContactsViewController: ListWithSearchViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.register(UINib.init(nibName: MemberViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberViewModel.cellIdentifier)
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.collectionView?.alpha = 0
        firstly {
            APIClient.shared.getDMRequests()
            }.then { items -> Void in
                print(items)
                
//                let cellWidth: CGFloat = self.view.frame.width
//                items.forEach({ (member) in
//                    let viewModel1 = MemberViewModel(member: member, cellSize: CGSize(width: cellWidth, height: 105))
//                    self.data.append(viewModel1)
//                })
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                self.collectionView?.alpha = 0
//                self.collectionView?.reloadData()
//                self.collectionView?.setContentOffset(CGPoint.init(x: 0, y: -20), animated: false)
//                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
//                    self.collectionView?.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
//                    self.collectionView?.alpha = 1
//                }, completion: { (_) in
//                    
//                })
            }.catch { error in
                debugPrint(error.localizedDescription)
        }
        
    }
    
    var selectedVM: MemberViewModel?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        if segue.identifier == "ShowMember" {
            if let vc = segue.destination as? MemberViewController, let selectedItem = selectedVM {
                vc.member = selectedItem.member
            }
        }
    }

}

extension ContactsViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? MemberViewModel {
            selectedVM = vm
            performSegue(withIdentifier: "ShowMember", sender: self)
        }
    }
}



extension ContactsViewController {
    
    override func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }
        
        var detailVC: UIViewController!
        
        if let vm = data[indexPath.item] as? MemberViewModel {
            selectedVM = vm
            detailVC = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "MemberViewController")
            (detailVC as! MemberViewController).member = selectedVM?.member
            
            //        detailVC.preferredContentSize = CGSize(width: 0.0, height: 300)
            previewingContext.sourceRect = cell.frame
            
            return detailVC
        }
        
        return nil
        
    }
}
