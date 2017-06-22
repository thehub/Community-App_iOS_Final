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

    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib.init(nibName: EventViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: EventViewModel.cellIdentifier)
        
        let item1 = Event(name: "A guide to reaching your sustainable development goals", date: Date().addingTimeInterval((60 * 60 * 24 * 12)), locationName: "London", address: "E5 0RF", photo: "eventPhoto")
        let item2 = Event(name: "A guide to reaching your sustainable development goals", date: Date().addingTimeInterval((60 * 60 * 24 * 12)), locationName: "London", address: "E5 0RF", photo: "eventPhoto")
        let item3 = Event(name: "A guide to reaching your sustainable development goals", date: Date().addingTimeInterval((60 * 60 * 24 * 12)), locationName: "London", address: "E5 0RF", photo: "eventPhoto")
        let item4 = Event(name: "A guide to reaching your sustainable development goals", date: Date().addingTimeInterval((60 * 60 * 24 * 12)), locationName: "London", address: "E5 0RF", photo: "eventPhoto")
        
        let cellWidth: CGFloat = self.view.frame.width
        let viewModel1 = EventViewModel(event: item1, cellSize: CGSize(width: cellWidth, height: 370))
        let viewModel2 = EventViewModel(event: item2, cellSize: CGSize(width: cellWidth, height: 370))
        let viewModel3 = EventViewModel(event: item3, cellSize: CGSize(width: cellWidth, height: 370))
        let viewModel4 = EventViewModel(event: item4, cellSize: CGSize(width: cellWidth, height: 370))
        
        self.data.append(viewModel1)
        self.data.append(viewModel2)
        self.data.append(viewModel3)
        self.data.append(viewModel4)

        self.data.append(viewModel1)
        self.data.append(viewModel2)
        self.data.append(viewModel3)
        self.data.append(viewModel4)

        self.data.append(viewModel1)
        self.data.append(viewModel2)
        self.data.append(viewModel3)
        self.data.append(viewModel4)

        
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
//        if segue.identifier == "ShowEvent" {
//            if let vc = segue.destination as? EventViewController, let selectedItem = selectedVM {
//                vc.event = selectedItem.event
//            }
//        }
    }
    
    
}

extension EventsViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vm = data[indexPath.item] as? EventViewModel {
            selectedVM = vm
//            performSegue(withIdentifier: "ShowEvent", sender: self)
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

//        if let vm = data[indexPath.item] as? ProjectViewModel {
//            selectedVM = vm
//            detailVC = storyboard?.instantiateViewController(withIdentifier: "EventViewController")
//            (detailVC as! EventViewController).event = selectedVM?.event
//
//            //        detailVC.preferredContentSize = CGSize(width: 0.0, height: 300)
//            previewingContext.sourceRect = cell.frame
//            
//            return detailVC
//        }
        
        return nil
        
    }
    
    override func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
}
