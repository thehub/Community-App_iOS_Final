//
//  CompaniesViewController.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit
import SalesforceSDKCore


class MembersViewController: ListWithSearchViewController, CreatePostViewControllerDelegate {

    
    override var filterSource: FilterManager.Source {
        get {
            return FilterManager.Source.members
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib.init(nibName: MemberViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MemberViewModel.cellIdentifier)
        
    }
    
    deinit {
        print("\(#file, #function)")
    }
    
    var offset: Int?
    var firstLoad = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.offset = nil
        self.firstLoad = true
        loadData()
    }
    
    func loadData() {
        self.isLoading = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if self.firstLoad {
            self.collectionView?.alpha = 0
        }
        firstly {
            ContactRequestManager.shared.refresh()
            }.then { contactRequests -> Void in
                print("refreshed")
            }.then {
                APIClient.shared.getMembers(offset: self.offset ?? 0)
            }.then { result -> Void in
                if self.firstLoad {
                    self.dataAll.removeAll()
                    self.data.removeAll()
                    self.collectionView.reloadData()
                }
                let cellWidth: CGFloat = self.view.frame.width
                self.offset = result.offset
                let members = result.members
                members.forEach({ (member) in
                    // Remove our selves
                    if member.contactId != SessionManager.shared.me?.member.contactId ?? "" {
                        member.contactRequest = ContactRequestManager.shared.getRelevantContactRequestFor(member: member)
                        self.dataAll.append(MemberViewModel(member: member, delegate: self, cellSize: CGSize(width: cellWidth, height: 105)))
                    }
                })
                
                // Create filters
                FilterManager.shared.clearPreviousFilters()
                // Create a Set of the existing tags per grouping
                // Cities
                FilterManager.shared.addFilters(fromTags: Set(members.flatMap({$0.impactHubCities}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .hub)
                // Skills
                FilterManager.shared.addFilters(fromTags: Set(members.flatMap({$0.skillTags}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .skill)
                // SDG goals
                FilterManager.shared.addFilters(fromTags: Set(members.flatMap({$0.interestedSDGs}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .sdg)
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                let previousCount = self.data.count
                if self.firstLoad {
                    self.data = self.filterData(dataToFilter: self.dataAll)
                    self.collectionView?.alpha = 0
                    self.collectionView?.reloadData()
                    self.collectionView?.setContentOffset(CGPoint.init(x: 0, y: -20), animated: false)
                    UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                        self.collectionView?.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
                        self.collectionView?.alpha = 1
                    }, completion: { (_) in
                        
                    })
                    self.firstLoad = false
                }
                else {
                    if self.searchBar?.text == nil || self.searchBar?.text == "" {
                        self.data = self.filterData(dataToFilter: self.dataAll)
                    }
                    else {
                        let dataFiltered = self.filterData(dataToFilter: self.dataAll)
                        self.data = self.filterContentForSearchText(dataToFilter: dataFiltered, searchText: self.searchBar?.text ?? "")
                    }
                    let indexPaths = (previousCount..<self.data.count).map { IndexPath(row: $0, section: 0) }
                    self.collectionView.insertItems(at: indexPaths)
                }
                self.isLoading = false
            }.catch { error in
                debugPrint(error.localizedDescription)
                self.isLoading = false
        }

    }
    
    var isLoading = false
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        if !isLoading && self.offset != nil && scrollView.contentOffset.y > scrollView.contentSize.height * 0.70 {
            loadData()
        }
    }

    override func searchFromServer(searchTerm: String) {
        super.searchFromServer(searchTerm: searchTerm)
        firstly {
            APIClient.shared.getMembers(searchTerm: searchTerm, offset: 0)
            }.then { result -> Void in
                let members = result.members
                var membersVMFromSearch = [CellRepresentable]()
                let cellWidth: CGFloat = self.view.frame.width
                members.forEach({ (member) in
                    // Remove our selves
                    // Remove any already shown on screen that we had locally, but also comes back from server search.
                    if member.contactId != SessionManager.shared.me?.member.contactId ?? "" && self.data.filter({($0 as! MemberViewModel).member.contactId == member.contactId}).count == 0 {
                        member.contactRequest = ContactRequestManager.shared.getRelevantContactRequestFor(member: member)
                        membersVMFromSearch.append(MemberViewModel(member: member, delegate: self, cellSize: CGSize(width: cellWidth, height: 105)))
                    }
                })
                let membersToAppendFromSearch = self.filterData(dataToFilter: membersVMFromSearch)
                self.data.append(contentsOf: membersToAppendFromSearch)
                self.collectionView.reloadData()

            
            }.always {
            }.catch { error in
                debugPrint(error.localizedDescription)
        }

    }
    
    override func filterData(dataToFilter: [CellRepresentable]) -> [CellRepresentable] {
        var filteredData = dataToFilter

        // City
        if filters.filter({$0.grouping == .hub}).count > 0  {
            filteredData = filteredData.filter { (cellVM) -> Bool in
                if let cellVM = cellVM as? MemberViewModel {
                    var matched = false
                    for filter in self.filters {
                        if filter.grouping == .hub {
                            if cellVM.member.impactHubCities?.lowercased().contains(filter.name.lowercased()) ?? false {
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
                if let cellVM = cellVM as? MemberViewModel {
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
                if let cellVM = cellVM as? MemberViewModel {
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
                if let cellVM = cellVM as? MemberViewModel {
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.cancelSearching()
    }
    
    var selectedVM: MemberViewModel?
    var memberToSendMessage: Member?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        if segue.identifier == "ShowMember" {
            if let vc = segue.destination as? MemberViewController, let selectedItem = selectedVM {
                vc.member = selectedItem.member
            }
        }
        else if segue.identifier == "ShowCreatePost" {
            if let navVC = segue.destination as? UINavigationController {
                if let vc = navVC.viewControllers.first as? CreatePostViewController, let contactId = cellWantsToSendContactRequest?.vm?.member.contactId {
                    vc.delegate = self
                    vc.createType = .contactRequest(contactId: contactId)
                }
            }
        }
        else if segue.identifier == "ShowMessageThread" {
            if let vc = segue.destination as? MessagesThreadViewController, let member = self.memberToSendMessage {
                vc.member = member
            }
        }
    }
    
    func didCreatePost(post: Post) {
        
    }
    
    func didCreateComment(comment: Comment) {
        
    }
    
    func didSendContactRequest() {
        self.cellWantsToSendContactRequest?.connectRequestStatus = .outstanding
        
        // Now refresh the status, so that when we push into the member, it can update the button correctly.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            ContactRequestManager.shared.refresh()
            }.then { contactRequests -> Void in
                for data in self.dataAll {
                    if let data2 = data as? MemberViewModel {
                        data2.member.contactRequest = ContactRequestManager.shared.getRelevantContactRequestFor(member: data2.member)
                    }
                }
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }.catch { error in
                debugPrint(error.localizedDescription)
        }
    }
    
    var cellWantsToSendContactRequest: MemberCollectionViewCell?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    
    
    
    // MARK: Search
    override func filterContentForSearchText(dataToFilter: [CellRepresentable], searchText:String) -> [CellRepresentable] {
        return dataToFilter.filter({ (item) -> Bool in
            if let vm = item as? MemberViewModel {
                return vm.member.name.lowercased().contains(searchText.lowercased()) || vm.member.locationName.lowercased().contains(searchText.lowercased())
            }
            else {
                return false
            }
        })
    }
    
    
}


extension MembersViewController: MemberCollectionViewCellDelegate {

    func wantsToCreateNewMessage(member: Member) {
        self.memberToSendMessage = member
        self.performSegue(withIdentifier: "ShowMessageThread", sender: self)
    }
    
    
    func wantsToSendContactRequest(member: Member, cell: MemberCollectionViewCell) {
        self.cellWantsToSendContactRequest = cell
        self.performSegue(withIdentifier: "ShowCreatePost", sender: self)
    }

}


extension MembersViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? MemberViewModel {
            selectedVM = vm
            performSegue(withIdentifier: "ShowMember", sender: self)
        }
    }
}



extension MembersViewController {
    
    override func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }

        var detailVC: UIViewController!

        if let vm = data[indexPath.item] as? MemberViewModel {
            selectedVM = vm
            detailVC = storyboard?.instantiateViewController(withIdentifier: "MemberViewController")
            (detailVC as! MemberViewController).member = selectedVM?.member

            //        detailVC.preferredContentSize = CGSize(width: 0.0, height: 300)
            previewingContext.sourceRect = cell.frame
            
            return detailVC
        }
        
        return nil
        
    }
}
