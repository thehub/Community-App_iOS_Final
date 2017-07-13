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

    
    var dataConnected = [CellRepresentable]()
    var dataIncomming = [CellRepresentable]()
    var dataAwaiting = [CellRepresentable]()

    private var contactIds = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.register(UINib.init(nibName: ContactViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ContactViewModel.cellIdentifier)
        
        topMenu?.setupWithItems(["CONNECTED", "INCOMING", "AWAITING"])
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.collectionView?.alpha = 0
        firstly {
            APIClient.shared.getDMRequests()
            }.then { contactRequests -> Void in
                // Get all contact requests again
                ContactRequestManager.shared.contactRequests = contactRequests
                self.contactIds = contactRequests.map { $0.contactToId }
            }.then {
                // Load members for the contactRequests we have
                APIClient.shared.getMembers(contactIds: self.contactIds)
            }.then { members -> Void in
                let cellWidth: CGFloat = self.view.frame.width
                
                // Connected
                let connected = ContactRequestManager.shared.getConnectedContactRequests()
                connected.forEach({ (connectionRequest) in
                    if let member = members.filter ({$0.id == connectionRequest.contactToId || $0.id == connectionRequest.contactFromId }).first {
                        let viewModel = ContactViewModel(member: member, connectionRequest: connectionRequest, cellSize: CGSize(width: cellWidth, height: 105))
                        self.dataConnected.append(viewModel)
                    }
                })

                // Incomming
                let incomming = ContactRequestManager.shared.getIncommingContactRequests()
                incomming.forEach({ (connectionRequest) in
                    if let member = members.filter ({$0.id == connectionRequest.contactToId || $0.id == connectionRequest.contactFromId }).first {
                        let viewModel = ContactViewModel(member: member, connectionRequest: connectionRequest, cellSize: CGSize(width: cellWidth, height: 105))
                        self.dataIncomming.append(viewModel)
                    }
                })

                // Awaiting
                let awaiting = ContactRequestManager.shared.getAwaitingContactRequests()
                awaiting.forEach({ (connectionRequest) in
                    if let member = members.filter ({$0.id == connectionRequest.contactToId || $0.id == connectionRequest.contactFromId }).first {
                        let viewModel = ContactViewModel(member: member, connectionRequest: connectionRequest, cellSize: CGSize(width: cellWidth, height: 105))
                        self.dataAwaiting.append(viewModel)
                    }
                })
                
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.collectionView?.alpha = 0
                self.collectionView?.reloadData()
                self.collectionView?.setContentOffset(CGPoint.init(x: 0, y: -20), animated: false)
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                    self.collectionView?.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
                    self.collectionView?.alpha = 1
                }, completion: { (_) in
                    
                })
            }.catch { error in
                debugPrint(error.localizedDescription)
        }
        
    }
    
    var selectedVM: ContactViewModel?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        if segue.identifier == "ShowMember" {
            if let vc = segue.destination as? MemberViewController, let selectedItem = selectedVM {
                vc.member = selectedItem.member
            }
        }
    }
    
    
    override func topMenuDidSelectIndex(_ index: Int) {
        
        self.collectionView.alpha = 0
        
        if index == 0 {
            self.data = self.dataConnected
            self.collectionView.reloadData()
        }
        else if index == 1 {
            self.data = self.dataIncomming
            self.collectionView.reloadData()
        }
        else if index == 2 {
            self.data = self.dataAwaiting
            self.collectionView.reloadData()
        }
        self.collectionView.scrollRectToVisible(CGRect.zero, animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collectionView.setContentOffset(CGPoint.init(x: 0, y: -20), animated: false)
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                self.collectionView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
                self.collectionView.alpha = 1
            }, completion: { (_) in
                
            })
        }
    }

}

extension ContactsViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? ContactViewModel {
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
        
        if let vm = data[indexPath.item] as? ContactViewModel {
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
