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

    override var filterSource: FilterManager.Source {
        get {
            return FilterManager.Source.members
        }
    }
    
    var dataConnected = [CellRepresentable]()
    var dataIncomming = [CellRepresentable]()
    var dataRejected = [CellRepresentable]()

    private var contactIds = Set<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.register(UINib.init(nibName: ContactViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ContactViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: ContactDeclinedViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ContactDeclinedViewModel.cellIdentifier)
        collectionView.register(UINib.init(nibName: ContactIncommingViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ContactIncommingViewModel.cellIdentifier)

        // NOTE: These have noew been renamed, so Pending is the old Incomming cell. And the old Pending has been removed.
        topMenu?.setupWithItems(["ACTIVE", "PENDING", "REJECTED"])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.cancelSearching()
    }

    var inTransit = false
    
    
    func loadData() {
        if inTransit {
            return
        }
        inTransit = true
        dataConnected.removeAll()
        dataIncomming.removeAll()
        dataRejected.removeAll()
        dataAll.removeAll()
        collectionView.reloadData()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.collectionView?.alpha = 0
        firstly {
            ContactRequestManager.shared.refresh()
            }.then { contactRequests -> Void in
                // Get all contact requests again
                let contactToIds = Set(contactRequests.map { $0.contactToId })
                let contactFromIds = Set(contactRequests.map { $0.contactFromId })
                self.contactIds = contactToIds.union(contactFromIds)
            }.then {
                // Load members for the contactRequests we have
                APIClient.shared.getMembers(contactIds: Array(self.contactIds))
            }.then { members -> Void in
                let cellWidth: CGFloat = self.view.frame.width
                // Active
                let connected = ContactRequestManager.shared.getConnectedContactRequests()
                members.forEach({ (member) in
                    if let contactRequest = connected.filter ({$0.contactToId == member.contactId || $0.contactFromId == member.contactId && $0.id != SessionManager.shared.me?.member.contactId}).first {
                        if member.contactId != SessionManager.shared.me!.member.contactId {
                            member.contactRequest = contactRequest
                            let viewModel = ContactViewModel(member: member, contactCellDelegate: self, cellSize: CGSize(width: cellWidth, height: 120))
                            self.dataConnected.append(viewModel)
                        }
                    }
                })
                self.data = self.filterData(dataToFilter: self.dataConnected)
                self.dataAll = self.data
                
                // Create filters
                FilterManager.shared.clearPreviousFilters()
                // Create a Set of the existing tags per grouping
                // Cities
                FilterManager.shared.addFilters(fromTags: Set(members.flatMap({$0.impactHubCities}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .city)
                // Skills
                FilterManager.shared.addFilters(fromTags: Set(members.flatMap({$0.skillTags}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .skill)
                // SDG goals
                FilterManager.shared.addFilters(fromTags: Set(members.flatMap({$0.interestedSDGs}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .sdg)
                
                // Pending Pending is the old Incomming cell. And the old Pending has been removed.
                let incomming = ContactRequestManager.shared.getIncommingContactRequests()
                incomming.forEach({ (contactRequest) in
                    if let member = members.filter ({$0.contactId == contactRequest.contactFromId && $0.contactId != SessionManager.shared.me?.member.contactId}).first {
                        member.contactRequest = contactRequest
                        let viewModel = ContactIncommingViewModel(member: member, contactCellDelegate: self, cellSize: CGSize(width: cellWidth, height: 215))
                        self.dataIncomming.append(viewModel)
                    }
                })
                
                // Rejected
                let declined = ContactRequestManager.shared.getDeclinedContactRequests()
                declined.forEach({ (contactRequest) in
                    // Only show this where the to user is the me, as if the from user declines it it'll be deleted, and in this case only the to user should be able to change the decline...
                    if contactRequest.contactToId == SessionManager.shared.me?.member.contactId {
                        if let member = members.filter ({$0.contactId == contactRequest.contactFromId }).first {
                            member.contactRequest = contactRequest
                            let viewModel = ContactDeclinedViewModel(member: member, contactCellDelegate: self, cellSize: CGSize(width: cellWidth, height: 105))
                            self.dataRejected.append(viewModel)
                        }
                    }
                })
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.topMenu?.selectButton(index: self.selectedTopMenuIndex)
                
                self.collectionView?.alpha = 0
                self.collectionView?.reloadData()
                self.collectionView?.setContentOffset(CGPoint.init(x: 0, y: -20), animated: false)
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                    self.collectionView?.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
                    self.collectionView?.alpha = 1
                }, completion: { (_) in
                    self.inTransit = false
                })
            }.catch { error in
                debugPrint(error.localizedDescription)
        }
        
    }
    
    var selectedTopMenuIndex: Int = 0
    var selectedVM: ContactViewModel?
    var selectedIncomingVM: ContactIncommingViewModel?
    var selectedMember: Member?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        if segue.identifier == "ShowMember" {
            if let vc = segue.destination as? MemberViewController, let selectedItem = selectedVM {
                vc.member = selectedItem.member
            }
        }
        if segue.identifier == "ShowIncomming" {
            if let vc = segue.destination as? ContactIncommingViewController, let selectedItem = selectedIncomingVM {
                vc.member = selectedItem.member
            }
        }
        if segue.identifier == "ShowMessageThread" {
            if let vc = segue.destination as? MessagesThreadViewController, let selectedMember = selectedMember {
                vc.member = selectedMember
            }
        }
    }
    
    
    override func topMenuDidSelectIndex(_ index: Int) {
        
        self.collectionView.alpha = 0
        self.selectedTopMenuIndex = index // cache it here for when we reload.
        
        if index == 0 {
            self.cancelSearching()
            self.data = self.filterData(dataToFilter: self.dataConnected)
            self.dataAll = self.data
            self.collectionView.reloadData()
            // Create filters
            FilterManager.shared.clearPreviousFilters()
            // Create a Set of the existing tags per grouping
            // Cities
            FilterManager.shared.addFilters(fromTags: Set(self.dataConnected.flatMap({($0 as! ContactViewModel).member.impactHubCities}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .city)
            // Skills
            FilterManager.shared.addFilters(fromTags: Set(self.dataConnected.flatMap({($0 as! ContactViewModel).member.skillTags}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .skill)
            // SDG goals
            FilterManager.shared.addFilters(fromTags: Set(self.dataConnected.flatMap({($0 as! ContactViewModel).member.interestedSDGs}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .sdg)
        }
        else if index == 1 {
            self.cancelSearching()
            self.data = self.filterData(dataToFilter: self.dataIncomming)
            self.dataAll = self.data
            self.collectionView.reloadData()
            // Create filters
            FilterManager.shared.clearPreviousFilters()
            // Create a Set of the existing tags per grouping
            // Cities
            FilterManager.shared.addFilters(fromTags: Set(self.dataIncomming.flatMap({($0 as! ContactIncommingViewModel).member.impactHubCities}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .city)
            // Skills
            FilterManager.shared.addFilters(fromTags: Set(self.dataIncomming.flatMap({($0 as! ContactIncommingViewModel).member.skillTags}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .skill)
            // SDG goals
            FilterManager.shared.addFilters(fromTags: Set(self.dataIncomming.flatMap({($0 as! ContactIncommingViewModel).member.interestedSDGs}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .sdg)
        }
        else if index == 2 {
            self.cancelSearching()
            self.data = self.filterData(dataToFilter: self.dataRejected)
            self.dataAll = self.data
            self.collectionView.reloadData()
            // Create filters
            FilterManager.shared.clearPreviousFilters()
            // Create a Set of the existing tags per grouping
            // Cities
            FilterManager.shared.addFilters(fromTags: Set(self.dataRejected.flatMap({($0 as! ContactDeclinedViewModel).member.impactHubCities}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .city)
            // Skills
            FilterManager.shared.addFilters(fromTags: Set(self.dataRejected.flatMap({($0 as! ContactDeclinedViewModel).member.skillTags}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .skill)
            // SDG goals
            FilterManager.shared.addFilters(fromTags: Set(self.dataRejected.flatMap({($0 as! ContactDeclinedViewModel).member.interestedSDGs}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .sdg)
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

    
    override func filterData(dataToFilter: [CellRepresentable]) -> [CellRepresentable] {
        var filteredData = dataToFilter
        
        // City
        if filters.filter({$0.grouping == .city}).count > 0  {
            filteredData = filteredData.filter { (cellVM) -> Bool in
                if let cellVM = cellVM as? ContactViewModel {
                    var matched = false
                    for filter in self.filters {
                        if filter.grouping == .city {
                            if cellVM.member.locationName.lowercased().contains(filter.name.lowercased()) {
                                matched = true
                            }
                        }
                    }
                    return matched
                }
                else {
                    return false
                }
            }
        }
        
        // Skills
        if filters.filter({$0.grouping == .skill}).count > 0  {
            filteredData = filteredData.filter { (cellVM) -> Bool in
                if let cellVM = cellVM as? ContactViewModel {
                    var matched = false
                    for filter in self.filters {
                        if filter.grouping == .skill {
                            if cellVM.member.skillTags?.lowercased().contains(filter.name.lowercased()) ?? false {
                                matched = true
                            }
                        }
                    }
                    return matched
                }
                else {
                    return false
                }
            }
        }
        
        // SDG goals
        if filters.filter({$0.grouping == .sdg}).count > 0  {
            filteredData = filteredData.filter { (cellVM) -> Bool in
                if let cellVM = cellVM as? ContactViewModel {
                    var matched = false
                    for filter in self.filters {
                        if filter.grouping == .sdg {
                            if cellVM.member.interestedSDGs?.lowercased().contains(filter.name.lowercased()) ?? false {
                                matched = true
                            }
                        }
                    }
                    return matched
                }
                else {
                    return false
                }
            }
        }
        
        // Sector
        if filters.filter({$0.grouping == .sector}).count > 0  {
            filteredData = filteredData.filter { (cellVM) -> Bool in
                if let cellVM = cellVM as? ContactViewModel {
                    var matched = false
                    for filter in self.filters {
                        if filter.grouping == .sector {
                            if cellVM.member.sector?.lowercased().contains(filter.name.lowercased()) ?? false {
                                matched = true
                            }
                        }
                    }
                    return matched
                }
                else {
                    return false
                }
            }
        }
        return filteredData
    }

        
    // MARK: Search
    override func filterContentForSearchText(dataToFilter: [CellRepresentable], searchText: String) -> [CellRepresentable] {
        return dataToFilter.filter({ (item) -> Bool in
            if selectedTopMenuIndex == 0 {
                if let vm = item as? ContactViewModel {
                    return vm.member.name.lowercased().contains(searchText.lowercased()) || vm.member.locationName.lowercased().contains(searchText.lowercased())
                }
                else {
                    return false
                }
            }
            else if selectedTopMenuIndex == 1 {
                if let vm = item as? ContactIncommingViewModel {
                    return vm.member.name.lowercased().contains(searchText.lowercased()) || vm.member.locationName.lowercased().contains(searchText.lowercased())
                }
                else {
                    return false
                }
            }
            else if selectedTopMenuIndex == 2 {
                if let vm = item as? ContactDeclinedViewModel {
                    return vm.member.name.lowercased().contains(searchText.lowercased()) || vm.member.locationName.lowercased().contains(searchText.lowercased())
                }
                else {
                    return false
                }
            }
            else {
                return false
            }
        })
    }
    
}

extension ContactsViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? ContactViewModel {
            selectedVM = vm
            performSegue(withIdentifier: "ShowMember", sender: self)
        }
        else if let vm = data[indexPath.item] as? ContactIncommingViewModel {
            selectedIncomingVM = vm
            performSegue(withIdentifier: "ShowIncomming", sender: self)
        }
    }
}

extension ContactsViewController: ContactCellDelegate {
    func didApprove(member: Member) -> Void {
        self.loadData()
    
    }
    
    func didDecline(member: Member) -> Void {
        self.loadData()
    }
    
    func wantsToCreateNewMessage(member: Member) {
        self.selectedMember = member
        self.performSegue(withIdentifier: "ShowMessageThread", sender: self)
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
