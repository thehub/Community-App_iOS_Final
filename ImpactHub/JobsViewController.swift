//
//  CompaniesViewController.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit

class JobsViewController: ListWithSearchViewController {

    override var filterSource: FilterManager.Source {
        get {
            return FilterManager.Source.jobs
        }
    }

    var offset: Int?
    var firstLoad = true
    var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib.init(nibName: JobViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: JobViewModel.cellIdentifier)
        
        loadData()
    }

    func loadData() {
        self.isLoading = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if self.firstLoad {
            self.collectionView?.alpha = 0
        }
        firstly {
            APIClient.shared.getJobs(offset: self.offset ?? 0)
            }.then { result -> Void in
                let jobs = result.jobs
                self.offset = result.offset
                jobs.forEach({ (job) in
                    self.dataAll.append(JobViewModel(job: job, cellSize: CGSize(width: self.view.frame.width, height: 145)))
                })
                
                // Create filters
                FilterManager.shared.clearPreviousFilters()
                // Create a Set of the existing tags per grouping
                // Cities
                FilterManager.shared.addFilters(fromTags: Set(jobs.flatMap({$0.locationName}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .city)
                // Sector
                FilterManager.shared.addFilters(fromTags: Set(jobs.flatMap({$0.sector}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .sector)
                // SDG goals
                FilterManager.shared.addFilters(fromTags: Set(jobs.flatMap({$0.relatedSDGs}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .sdg)
                // Job Type
                FilterManager.shared.addFilters(fromTags: Set(jobs.flatMap({$0.type}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .jobType)
                
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                let previousCount = self.data.count
                self.data = self.filterData(dataToFilter: self.dataAll)
                if self.firstLoad {
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
                    let indexPaths = (previousCount..<self.data.count).map { IndexPath(row: $0, section: 0) }
                    self.collectionView.insertItems(at: indexPaths)
                }
                self.isLoading = false
            }.catch { error in
                debugPrint(error.localizedDescription)
                self.isLoading = false
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        if !isLoading && self.offset != nil && scrollView.contentOffset.y > scrollView.contentSize.height * 0.70 {
            loadData()
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
                if let cellVM = cellVM as? JobViewModel {
                    var matched = false
                    for filter in self.filters {
                        if filter.grouping == .city {
                            if cellVM.job.locationName.lowercased().contains(filter.name.lowercased()) {
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
                if let cellVM = cellVM as? JobViewModel {
                    var matched = false
                    for filter in self.filters {
                        if filter.grouping == .sdg {
                            if cellVM.job.relatedSDGs?.lowercased().contains(filter.name.lowercased()) ?? false {
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
                if let cellVM = cellVM as? JobViewModel {
                    var matched = false
                    for filter in self.filters {
                        if filter.grouping == .sector {
                            if cellVM.job.sector?.lowercased().contains(filter.name.lowercased()) ?? false {
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
        
        // Job Type
        if filters.filter({$0.grouping == .jobType}).count > 0  {
            filteredData = filteredData.filter { (cellVM) -> Bool in
                if let cellVM = cellVM as? JobViewModel {
                    var matched = false
                    for filter in self.filters {
                        if filter.grouping == .jobType {
                            if cellVM.job.type.lowercased().contains(filter.name.lowercased()) {
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
    
    
    var selectedVM: JobViewModel?
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        if segue.identifier == "ShowJob" {
            if let vc = segue.destination as? JobViewController, let selectedItem = selectedVM {
                vc.job = selectedItem.job
            }
        }
    }
    
    // MARK: Search
    
    override func filterContentForSearchText(dataToFilter: [CellRepresentable], searchText: String) -> [CellRepresentable] {
        return dataToFilter.filter({ (item) -> Bool in
            if let vm = item as? JobViewModel {
                let sector = vm.job.sector ?? ""
                return vm.job.name.lowercased().contains(searchText.lowercased()) || vm.job.locationName.lowercased().contains(searchText.lowercased()) || vm.job.description.lowercased().contains(searchText.lowercased()) || vm.job.company.name.lowercased().contains(searchText.lowercased()) || sector.lowercased().contains(searchText.lowercased())
            }
            else {
                return false
            }
        })
    }
    
}


extension JobsViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? JobViewModel {
            selectedVM = vm
            performSegue(withIdentifier: "ShowJob", sender: self)
        }
    }
}

extension JobsViewController {
    
    override func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }

        var detailVC: UIViewController!

        if let vm = data[indexPath.item] as? JobViewModel {
            selectedVM = vm
            detailVC = storyboard?.instantiateViewController(withIdentifier: "JobViewController")
            (detailVC as! JobViewController).job = selectedVM?.job

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
