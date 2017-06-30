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

    var allData = [CellRepresentable]()
    var eventsYouManageData = [CellRepresentable]()
    var yourEventData = [CellRepresentable]()

    override var filterSource: FilterManager.Source {
        get {
            return FilterManager.Source.events
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib.init(nibName: EventViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: EventViewModel.cellIdentifier)
        
        let item1 = Event(name: "A guide to reaching your sustainable development goals", date: Date().addingTimeInterval((60 * 60 * 24 * 12)), locationName: "London", address: "E5 0RF", photo: "eventPhoto", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", price: "Free")
        let item2 = Event(name: "A guide to reaching your sustainable development goals", date: Date().addingTimeInterval((60 * 60 * 24 * 12)), locationName: "London", address: "E5 0RF", photo: "eventPhoto", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", price: "Free")
        let item3 = Event(name: "A guide to reaching your sustainable development goals", date: Date().addingTimeInterval((60 * 60 * 24 * 12)), locationName: "London", address: "E5 0RF", photo: "eventPhoto", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", price: "Free")
        let item4 = Event(name: "A guide to reaching your sustainable development goals", date: Date().addingTimeInterval((60 * 60 * 24 * 12)), locationName: "London", address: "E5 0RF", photo: "eventPhoto", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.", price: "Free")
        
        let cellWidth: CGFloat = self.view.frame.width
        let viewModel1 = EventViewModel(event: item1, cellSize: CGSize(width: cellWidth, height: 370))
        let viewModel2 = EventViewModel(event: item2, cellSize: CGSize(width: cellWidth, height: 370))
        let viewModel3 = EventViewModel(event: item3, cellSize: CGSize(width: cellWidth, height: 370))
        let viewModel4 = EventViewModel(event: item4, cellSize: CGSize(width: cellWidth, height: 370))
        
        self.allData.append(viewModel1)
        self.allData.append(viewModel2)
        self.allData.append(viewModel3)
        self.allData.append(viewModel4)

        self.allData.append(viewModel1)
        self.allData.append(viewModel2)
        self.allData.append(viewModel3)
        self.allData.append(viewModel4)

        self.allData.append(viewModel1)
        self.allData.append(viewModel2)
        self.allData.append(viewModel3)
        self.allData.append(viewModel4)
        
        self.data = allData
        
        // todo:
        self.eventsYouManageData = Array(allData[0...4])
        self.yourEventData = Array(allData[4...7])

        topMenu?.setupWithItems(["ALL", "EVENTS YOU MANAGE", "YOUR EVENTS"])

        // Do any additional setup after loading the view.
        
        
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        firstly {
//            APIClient.shared.getJobs(skip: 0, top: 100)
//            }.then { items -> Void in
//                print(items)
////                self.dataSource = items
////                self.collectionView?.reloadData()
//            }.always {
//                UIApplication.shared.isNetworkActivityIndicatorVisible = false
//            }.catch { error in
//                debugPrint(error.localizedDescription)
//        }
    
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
            self.data = self.allData
            self.collectionView.reloadData()
        }
        else if index == 1 {
            self.data = self.eventsYouManageData
            self.collectionView.reloadData()
        }
        else if index == 2 {
            self.data = self.yourEventData
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
