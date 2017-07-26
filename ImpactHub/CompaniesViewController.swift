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
                print(items)
                let cellWidth: CGFloat = self.view.frame.width - 30
                items.forEach({ (company) in
                    let viewModel1 = CompanyViewModel(company: company, cellSize: CGSize(width: cellWidth, height: 200))
                    self.dataAll.append(viewModel1)
                })
                self.data = self.dataAll
                self.collectionView?.reloadData()
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
    override func filterContentForSearchText(searchText:String) -> [CellRepresentable] {
        return self.dataAll.filter({ (item) -> Bool in
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
