//
//  GroupsViewController.swift
//  ImpactHub
//
//  Created by Niklas on 24/07/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit

class GroupsViewController: ListWithSearchViewController {
    
    var groupsYouManageData = [CellRepresentable]()
    var yourGroupsData = [CellRepresentable]()

    override var filterSource: FilterManager.Source {
        get {
            return FilterManager.Source.groups
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topMenu?.setupWithItems(["ALL", "GROUPS YOU MANAGE", "YOUR GROUPS"])
        
        collectionView.register(UINib.init(nibName: GroupViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: GroupViewModel.cellIdentifier)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.collectionView?.alpha = 0
        
        firstly {
                MyGroupsManager.shared.refresh()
            }.then { myGroupsIds -> Void in
                print("refreshed")
            }.then {
                APIClient.shared.getGroups()
            }.then { items -> Void in
                let filteredItems = items.filter {$0.groupType == .public || MyGroupsManager.shared.isInGroup(groupId: $0.chatterId)}
                filteredItems.forEach({ (group) in
                    self.dataAll.append(GroupViewModel(group: group, cellSize: CGSize(width: self.view.frame.width, height: 170)))
                })
                // Create filters
                FilterManager.shared.clearPreviousFilters()
                // Create a Set of the existing tags per grouping
                // Cities
                FilterManager.shared.addFilters(fromTags: Set(items.flatMap({$0.impactHubCities}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .city)
                // Sector
                FilterManager.shared.addFilters(fromTags: Set(items.flatMap({$0.sector}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .sector)
                // SDG goals
                FilterManager.shared.addFilters(fromTags: Set(items.flatMap({$0.relatedSDGs}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .sdg)
            }.then {_ in
                APIClient.shared.getGroups(contactId: SessionManager.shared.me?.member.contactId ?? "")
            }.then { yourGroups -> Void in
                let cellWidth: CGFloat = self.view.frame.width
                yourGroups.forEach({ (group) in
                    let viewModel = GroupViewModel(group: group, cellSize: CGSize(width: cellWidth, height: 170))
                    self.yourGroupsData.append(viewModel)
                })
            }.then {_ in
                APIClient.shared.getGroupsYouManage(contactId: SessionManager.shared.me?.member.contactId ?? "")
            }.then { manageGroups -> Void in
                let cellWidth: CGFloat = self.view.frame.width
                manageGroups.forEach({ (group) in
                    let viewModel = GroupViewModel(group: group, cellSize: CGSize(width: cellWidth, height: 170))
                    self.groupsYouManageData.append(viewModel)
                })
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.data = self.filterData(dataToFilter: self.dataAll)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _ = MyGroupsManager.shared.refresh()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        collectionViewLayout?.sectionInset = UIEdgeInsetsMake(self.searchContainer.frame.height + 20, 0, 60, 0)
        collectionViewLayout?.invalidateLayout()
    }
    
    
    
    deinit {
        print("\(#file, #function)")
    }
    
    override func topMenuDidSelectIndex(_ index: Int) {
        
        self.collectionView.alpha = 0
        
        if index == 0 {
            self.cancelSearching()
            self.data = self.dataAll
            self.collectionView.reloadData()
        }
        else if index == 1 {
            self.cancelSearching()
            self.data = self.groupsYouManageData
            self.collectionView.reloadData()
        }
        else if index == 2 {
            self.cancelSearching()
            self.data = self.yourGroupsData
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
    
    override func filterData(dataToFilter: [CellRepresentable]) -> [CellRepresentable] {
        var filteredData = dataToFilter
        
        // City
        if filters.filter({$0.grouping == .city}).count > 0  {
            filteredData = filteredData.filter { (cellVM) -> Bool in
                if let cellVM = cellVM as? GroupViewModel {
                    var matched = false
                    for filter in self.filters {
                        if filter.grouping == .city {
                            if cellVM.group.impactHubCities?.lowercased().contains(filter.name.lowercased()) ?? false {
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
//        if filters.filter({$0.grouping == .sdg}).count > 0  {
//            filteredData = filteredData.filter { (cellVM) -> Bool in
//                if let cellVM = cellVM as? GroupViewModel {
//                    var matched = false
//                    for filter in self.filters {
//                        if filter.grouping == .sdg {
//                            if cellVM.group.affiliatedSDGs?.lowercased().contains(filter.name.lowercased()) ?? false {
//                                matched = true
//                            }
//                        }
//                    }
//                    return matched
//                }
//                else {
//                    return false
//                }
//            }
//        }
        
        // Sector
        if filters.filter({$0.grouping == .sector}).count > 0  {
            filteredData = filteredData.filter { (cellVM) -> Bool in
                if let cellVM = cellVM as? GroupViewModel {
                    var matched = false
                    for filter in self.filters {
                        if filter.grouping == .sector {
                            if cellVM.group.sector?.lowercased().contains(filter.name.lowercased()) ?? false {
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
    
    
    var selectedVM: GroupViewModel?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        if segue.identifier == "ShowGroup" {
            if let vc = segue.destination as? GroupViewController, let selectedItem = selectedVM {
                vc.group = selectedItem.group
            }
        }
    }
    
    // MARK: Search
    override func filterContentForSearchText(dataToFilter: [CellRepresentable], searchText: String) -> [CellRepresentable] {
        return dataToFilter.filter({ (item) -> Bool in
            if let vm = item as? GroupViewModel {
                let locationName = vm.group.locationName ?? ""
                let description = vm.group.description ?? ""
                return vm.group.name.lowercased().contains(searchText.lowercased()) || locationName.lowercased().contains(searchText.lowercased()) || description.lowercased().contains(searchText.lowercased())
            }
            else {
                return false
            }
        })
    }
    
}


extension GroupsViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? GroupViewModel {
            selectedVM = vm
            performSegue(withIdentifier: "ShowGroup", sender: self)
        }
    }
}

extension GroupsViewController {
    
    override func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }
        
        var detailVC: UIViewController!
        
        if let vm = data[indexPath.item] as? GroupViewModel {
            selectedVM = vm
            detailVC = storyboard?.instantiateViewController(withIdentifier: "GroupViewController")
            (detailVC as! GroupViewController).group = selectedVM?.group
            
            //        detailVC.preferredContentSize = CGSize(width: 0.0, height: 300)
            previewingContext.sourceRect = cell.frame
            
            return detailVC
        }
        
        return nil
        
    }
    
    override func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
}

