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

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib.init(nibName: JobViewModel.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: JobViewModel.cellIdentifier)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.collectionView?.alpha = 0
        firstly {
            APIClient.shared.getJobs(skip: 0, top: 100)
            }.then { jobs -> Void in
                jobs.forEach({ (job) in
                    self.dataAll.append(JobViewModel(job: job, cellSize: CGSize(width: self.view.frame.width, height: 145)))
                })
            }.always {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.data = self.dataAll
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
    override func filterContentForSearchText(searchText:String) -> [CellRepresentable] {
        return self.dataAll.filter({ (item) -> Bool in
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
