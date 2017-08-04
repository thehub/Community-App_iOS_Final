//
//  CompaniesViewController.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit

class CompaniesViewController: ListWithSearchViewController {

    override var filterSource: FilterManager.Source {
        get {
            return FilterManager.Source.companies
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib.init(nibName: "CompanyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CompanyCell")
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.collectionView?.alpha = 0
        firstly {
            APIClient.shared.getCompanies()
            }.then { items -> Void in
                let cellWidth: CGFloat = self.view.frame.width - 30
                items.forEach({ (company) in
                    let viewModel1 = CompanyViewModel(company: company, cellSize: CGSize(width: cellWidth, height: 200))
                    self.dataAll.append(viewModel1)
                })
                self.data = self.filterData(dataToFilter: self.dataAll)
                self.collectionView?.reloadData()
                
                // Create filters
                FilterManager.shared.clearPreviousFilters()
                // Create a Set of the existing tags per grouping
                // Cities
                FilterManager.shared.addFilters(fromTags: Set(items.flatMap({$0.impactHubCities}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .city)
                // Sector
                FilterManager.shared.addFilters(fromTags: Set(items.flatMap({$0.sector}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .sector)
                // SDG goals
                FilterManager.shared.addFilters(fromTags: Set(items.flatMap({$0.affiliatedSDGs}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .sdg)
                // Size
                FilterManager.shared.addFilters(fromTags: Set(items.flatMap({$0.size}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .size)

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
    
    deinit {
        print("\(#file, #function)")
    }

    override func filterData(dataToFilter: [CellRepresentable]) -> [CellRepresentable] {
        var filteredData = dataToFilter
        
        // City
        if filters.filter({$0.grouping == .city}).count > 0  {
            filteredData = filteredData.filter { (cellVM) -> Bool in
                if let cellVM = cellVM as? CompanyViewModel {
                    var matched = false
                    for filter in self.filters {
                        if filter.grouping == .city {
                            if cellVM.company.locationName?.lowercased().contains(filter.name.lowercased()) ?? false {
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
                if let cellVM = cellVM as? CompanyViewModel {
                    var matched = false
                    for filter in self.filters {
                        if filter.grouping == .sdg {
                            if cellVM.company.affiliatedSDGs?.lowercased().contains(filter.name.lowercased()) ?? false {
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
                if let cellVM = cellVM as? CompanyViewModel {
                    var matched = false
                    for filter in self.filters {
                        if filter.grouping == .sector {
                            if cellVM.company.sector?.lowercased().contains(filter.name.lowercased()) ?? false {
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
        
        // Size
        if filters.filter({$0.grouping == .size}).count > 0  {
            filteredData = filteredData.filter { (cellVM) -> Bool in
                if let cellVM = cellVM as? CompanyViewModel {
                    var matched = false
                    for filter in self.filters {
                        if filter.grouping == .size {
                            if cellVM.company.size?.lowercased().contains(filter.name.lowercased()) ?? false {
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
    
    
    var selectedVM: CompanyViewModel?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        if segue.identifier == "ShowCompany" {
            if let vc = segue.destination as? CompanyViewController, let selectedItem = selectedVM {
                vc.company = selectedItem.company
            }
        }
    }
    
    
    // MARK: Search
    override func filterContentForSearchText(dataToFilter: [CellRepresentable], searchText: String) -> [CellRepresentable] {
        return dataToFilter.filter({ (item) -> Bool in
            if let vm = item as? CompanyViewModel {
                let sector = vm.company.sector ?? ""
                let locationName = vm.company.locationName ?? ""
                return vm.company.name.lowercased().contains(searchText.lowercased()) || sector.lowercased().contains(searchText.lowercased()) || locationName.lowercased().contains(searchText.lowercased())
            }
            else {
                return false
            }
        })
    }
    
}

extension CompaniesViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? CompanyViewModel {
            selectedVM = vm
            performSegue(withIdentifier: "ShowCompany", sender: self)
        }
    }
}

extension CompaniesViewController {
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth: CGFloat = self.collectionView.frame.width
        let width = ((cellWidth - 40) / 1.6)
        let heightToUse = width + 155
        return CGSize(width: view.frame.width, height: heightToUse)
        
    }
}
extension CompaniesViewController {
    
    override func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }
        
        var detailVC: UIViewController!
        
        if let vm = data[indexPath.item] as? CompanyViewModel {
            selectedVM = vm
            detailVC = storyboard?.instantiateViewController(withIdentifier: "CompanyViewController")
            (detailVC as! CompanyViewController).company = selectedVM?.company
            
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
