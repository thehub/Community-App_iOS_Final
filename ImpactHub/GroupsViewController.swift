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
    
    override var filterSource: FilterManager.Source {
        get {
            return FilterManager.Source.jobs
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib.init(nibName: GroupViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: GroupViewModel.cellIdentifier)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.collectionView?.alpha = 0
        firstly {
            APIClient.shared.getGroups(contactId: SessionManager.shared.me?.member.id ?? "")
            }.then { groups -> Void in
                groups.forEach({ (group) in
                    self.dataAll.append(GroupViewModel(group: group, cellSize: CGSize(width: self.view.frame.width, height: 170)))
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
    
    
    override func filterData(dataToFilter: [CellRepresentable]) -> [CellRepresentable] {
        // City
        //        if filters.filter({$0.grouping == .city}).count > 0  {
        //            let filteredData = dataToFilter.filter { (cellVM) -> Bool in
        //                if let cellVM = cellVM as? MemberViewModel {
        //                    var matchedCity = false
        //                    for filter in self.filters {
        //                        if filter.grouping == .city {
        //                            if cellVM.member.locationName.lowercased() == filter.name.lowercased() {
        //                                matchedCity = true
        //                            }
        //                        }
        //                    }
        //                    return matchedCity
        //                }
        //                else {
        //                    return false
        //                }
        //            }
        //            return filteredData
        //        }
        //        else {
        return dataToFilter
        //        }
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
                return vm.group.name.lowercased().contains(searchText.lowercased()) || locationName.contains(searchText.lowercased()) || description.lowercased().contains(searchText.lowercased())
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

