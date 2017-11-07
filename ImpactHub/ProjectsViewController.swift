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

class ProjectsViewController: ListWithSearchViewController {

    var projectsYouManageData = [CellRepresentable]()
    var yourProjectsData = [CellRepresentable]()

    override var filterSource: FilterManager.Source {
        get {
            return FilterManager.Source.projects
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib.init(nibName: ProjectViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: ProjectViewModel.cellIdentifier)
        
        topMenu?.setupWithItems(["ALL", "PROJECTS YOU MANAGE", "YOUR PROJECTS"])

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.collectionView?.alpha = 0
        firstly {
                MyGroupsManager.shared.refresh()
            }.then { myGroupsIds -> Void in
                print("refreshed")
            }.then {
                APIClient.shared.getProjects()
            }.then { items -> Void in
                let cellWidth: CGFloat = self.view.frame.width
                let filteredItems = items.filter {$0.groupType == .public || MyGroupsManager.shared.isInGroup(groupId: $0.chatterId)}
                filteredItems.forEach({ (project) in
                    let viewModel = ProjectViewModel(project: project, cellSize: CGSize(width: cellWidth, height: 370))
                    self.dataAll.append(viewModel)
                    if viewModel.project.createdById == SessionManager.shared.me?.member.contactId {
                        self.projectsYouManageData.append(viewModel)
                    }
                })
                self.data = self.filterData(dataToFilter: self.dataAll)
                
                // Create filters
                FilterManager.shared.clearPreviousFilters()
                // Create a Set of the existing tags per grouping
                // Cities
                FilterManager.shared.addFilters(fromTags: Set(items.flatMap({$0.impactHubCities}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .city)
                // Sector
                FilterManager.shared.addFilters(fromTags: Set(items.flatMap({$0.sector}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .sector)
//                // SDG goals
                FilterManager.shared.addFilters(fromTags: Set(items.flatMap({$0.relatedSDGs}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .sdg)
                
            }.then {_ in 
                APIClient.shared.getProjects(contactId: SessionManager.shared.me?.member.contactId ?? "")
            }.then { yourProjects -> Void in
                let cellWidth: CGFloat = self.view.frame.width
                yourProjects.forEach({ (project) in
                    let viewModel = ProjectViewModel(project: project, cellSize: CGSize(width: cellWidth, height: 370))
                    self.yourProjectsData.append(viewModel)
                })
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.collectionView?.alpha = 0
                self.collectionView?.reloadData()
                self.collectionView?.setContentOffset(CGPoint.init(x: 0, y: -80), animated: false)
                UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                    self.collectionView?.setContentOffset(CGPoint.init(x: 0, y: -60), animated: false)
                    self.collectionView?.alpha = 1
                }, completion: { (_) in
                    
                })
                
            }.catch { error in
                debugPrint(error.localizedDescription)
        }
        
    }
    
    deinit {
        print("\(#file, #function)")
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
    
    var selectedVM: ProjectViewModel?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        if segue.identifier == "ShowProject" {
            if let vc = segue.destination as? ProjectViewController, let selectedItem = selectedVM {
                vc.project = selectedItem.project
            }
        }
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
            self.data = self.projectsYouManageData
            self.collectionView.reloadData()
        }
        else if index == 2 {
            self.cancelSearching()
            self.data = self.yourProjectsData
            self.collectionView.reloadData()
        }
        self.collectionView.scrollRectToVisible(CGRect.zero, animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.collectionView.setContentOffset(CGPoint.init(x: 0, y: -80), animated: false)
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                self.collectionView.setContentOffset(CGPoint.init(x: 0, y: -60), animated: false)
                self.collectionView.alpha = 1
            }, completion: { (_) in
                
            })
        }
    }
    
    // MARK: Search
    
    override func filterContentForSearchText(dataToFilter: [CellRepresentable], searchText: String) -> [CellRepresentable] {
        return dataToFilter.filter({ (item) -> Bool in
            if let vm = item as? ProjectViewModel {
                let companyName = vm.project.companyName ?? ""
                let locationName = vm.project.locationName ?? ""
                return vm.project.name.lowercased().contains(searchText.lowercased()) || companyName.lowercased().contains(searchText.lowercased()) || locationName.lowercased().contains(searchText.lowercased())
            }
            else {
                return false
            }
        })
    }
}

extension ProjectsViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? ProjectViewModel {
            selectedVM = vm
            performSegue(withIdentifier: "ShowProject", sender: self)
        }
    }
}

extension ProjectsViewController {
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth: CGFloat = self.collectionView.frame.width
        let width = ((cellWidth - 40) / 1.6)
        let heightToUse = width + 155
        return CGSize(width: view.frame.width, height: heightToUse)
        
    }
}

extension ProjectsViewController {
    
    override func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }

        var detailVC: UIViewController!

        if let vm = data[indexPath.item] as? ProjectViewModel {
            selectedVM = vm
            detailVC = storyboard?.instantiateViewController(withIdentifier: "ProjectViewController")
            (detailVC as! ProjectViewController).project = selectedVM?.project

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
