//
//  CompaniesViewController.swift
//  ImpactHub
//
//  Created by Niklas on 17/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit
import PromiseKit

class EventsViewController: ListWithSearchViewController {

    var attendingData = [CellRepresentable]()
    var hostingData = [CellRepresentable]()

    override var filterSource: FilterManager.Source {
        get {
            return FilterManager.Source.events
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib.init(nibName: EventViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: EventViewModel.cellIdentifier)
        
        topMenu?.setupWithItems(["ALL", "ATTENDING", "HOSTING"])

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.collectionView?.alpha = 0
        firstly {
            APIClient.shared.getEvents()
            }.then { events -> Void in
                events.forEach({ (event) in
                    self.dataAll.append(EventViewModel(event: event, cellSize: CGSize(width: self.view.frame.width, height: 370)))
                })
                
//                // Create filters
                FilterManager.shared.clearPreviousFilters()
//                // Create a Set of the existing tags per grouping
//                // Cities
                FilterManager.shared.addFilters(fromTags: Set(events.flatMap({$0.city}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .city)
//                // Sector
                FilterManager.shared.addFilters(fromTags: Set(events.flatMap({$0.sector}).joined(separator: ";").components(separatedBy: ";").filter({$0 != ""})), forGrouping: .sector)
              
            }.then {
                APIClient.shared.getEventsAttending(contactId: SessionManager.shared.me?.member.contactId ?? "")
            }.then { eventsAttending -> Void in
                eventsAttending.forEach({ (event) in
                    self.attendingData.append(EventViewModel(event: event, cellSize: CGSize(width: self.view.frame.width, height: 370)))
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
    
    deinit {
        print("\(#file, #function)")
    }
    
    override func filterData(dataToFilter: [CellRepresentable]) -> [CellRepresentable] {
        var filteredData = dataToFilter
        
        // City
        if filters.filter({$0.grouping == .city}).count > 0  {
            filteredData = filteredData.filter { (cellVM) -> Bool in
                if let cellVM = cellVM as? EventViewModel {
                    var matched = false
                    for filter in self.filters {
                        if filter.grouping == .city {
                            if cellVM.event.city.lowercased().contains(filter.name.lowercased()) {
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
                if let cellVM = cellVM as? EventViewModel {
                    var matched = false
                    for filter in self.filters {
                        if filter.grouping == .sector {
                            if cellVM.event.sector.lowercased().contains(filter.name.lowercased()){
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
    
    var selectedVM: EventViewModel?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: self)
        if segue.identifier == "ShowEvent" {
            if let vc = segue.destination as? EventViewController, let selectedItem = selectedVM {
                vc.event = selectedItem.event
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
            self.data = self.attendingData
            self.collectionView.reloadData()
        }
        else if index == 2 {
            self.cancelSearching()
            self.data = self.hostingData
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
    
    // MARK: Search
    override func filterContentForSearchText(dataToFilter: [CellRepresentable], searchText: String) -> [CellRepresentable] {
        return dataToFilter.filter({ (item) -> Bool in
            if let vm = item as? EventViewModel {
                let locationName = vm.event.city
                let description = vm.event.description
                let result = vm.event.name.lowercased().contains(searchText.lowercased()) || locationName.lowercased().contains(searchText.lowercased()) || description.lowercased().contains(searchText.lowercased())
                return result
            }
            else {
                return false
            }
        })
    }
}

extension EventsViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? EventViewModel {
            selectedVM = vm
            performSegue(withIdentifier: "ShowEvent", sender: self)
        }
    }
}

extension EventsViewController {
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth: CGFloat = self.collectionView.frame.width
        let width = ((cellWidth - 40) / 1.6)
        let heightToUse = width + 155
        return CGSize(width: view.frame.width, height: heightToUse)
        
    }
}

extension EventsViewController {
    
    override func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return nil }

        var detailVC: UIViewController!

        if let vm = data[indexPath.item] as? EventViewModel {
            selectedVM = vm
            detailVC = storyboard?.instantiateViewController(withIdentifier: "EventViewController")
            (detailVC as! EventViewController).event = selectedVM?.event

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
